//
//  MapGeofireViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 14/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GeoFire

class MapGeofireViewController: UIViewController {
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var markers = [PlaceMarker]()
    var circles = [PlaceCircle]()
    var justOnceBool = true
    let locationManager = CLLocationManager()
    let geofireRef = Database.database().reference()
    var geoFireCompanies: GeoFire?
    var geoFireLocationUsers: GeoFire?
    let radiusCircle: CLLocationDistance = 50
    var getNearbyPlacesQuery: GFCircleQuery?
    var circleQueriesPlaces = [GFCircleQuery]()
    var user: User?
    var uid = "none"
    
    public lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        return mapView
    }()
    
    
    @objc public func handleUpdateLocation(){
        //justOnceBool = true
        locationManager.startUpdatingLocation()
    }
    
    private func updateGeofences(){
        justOnceBool = true
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = auth.currentUser
        uid = user?.uid ?? "none"
        geoFireCompanies = GeoFire(firebaseRef: geofireRef.child("companies_geofire"))
        geoFireLocationUsers = GeoFire(firebaseRef: geofireRef.child("users_location"))
        
        
        setupViews()
        setupLocationManager()
        setupNavBar()
        
    }
    
    
    func setupNavBar(){
        navigationItem.title = "salut"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.reply, target: self, action: #selector(handleUpdateLocation))
    }
    
    
    
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.activityType = CLActivityType.fitness
    }
    
    private func getNearbyPlaces(position: CLLocation){
        removeGeoQueries()
        let coordinateUser = position.coordinate
        let latitudeUser = coordinateUser.latitude
        let longitudeUser = coordinateUser.longitude
        
        let center = CLLocation(latitude: latitudeUser, longitude: longitudeUser)
        getNearbyPlacesQuery = geoFireCompanies?.query(at: center, withRadius: 3000/1000) //    meters/1000
        
        getNearbyPlacesQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            print("Key '\(key ?? "none")' entered the search area and is at location '\(location ?? GeoPoint(latitude: 1, longitude: 1))'")
            let coordinatePlace = location.coordinate
            let latitude = coordinatePlace.latitude
            let longitude = coordinatePlace.longitude
            let note = "\(latitude) \(longitude)"
            self.addDraw(forGeotification: Geotification(coordinate: coordinatePlace, radius: self.radiusCircle, identifier: key, note: note, eventType: Geotification.EventType.onEntry))
            
            self.queryGeofences(location: location)
            
        })
        getNearbyPlacesQuery?.observe(.keyExited, with: { (key: String!, location: CLLocation!) in
            print("Key '\(key ?? "none")' exited the search area and is at location '\(location ?? GeoPoint(latitude: 1, longitude: 1))'")
            //let coordinatePlace = location.coordinate
            self.updateGeofences()
        })
        
        
    }
    
    private func queryGeofences(location: CLLocation){
        let center = location
        if let circleQuery = self.geoFireLocationUsers?.query(at: center, withRadius: self.radiusCircle/1000){
            self.circleQueriesPlaces.append(circleQuery)
            circleQuery.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
                print("sabrina")
                print("Key '\(key ?? "none")' entered the search area and is at location '\(location ?? GeoPoint(latitude: 1, longitude: 1))'")
                self.setDrawYellow(identifier: key)
                self.displayEmployees()
                
            })
            circleQuery.observe(.keyExited) { (key: String!, location: CLLocation!) in
                print("Key '\(key ?? "none")' exited the search area and is at location '\(location ?? GeoPoint(latitude: 1, longitude: 1))'")
                self.resetDraw(identifier: key)
            }
        }
    }
    
    
    private func displayEmployees(){
        print("try to display employees")
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "Display Employees"
        notificationContent.sound = UNNotificationSound.default
        notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "display",
                                            content: notificationContent,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func removeGeoQueries(){
        getNearbyPlacesQuery?.removeAllObservers()
        for circleQuery in circleQueriesPlaces{
            circleQuery.removeAllObservers()
        }
    }
    
    
    // MARK: Map overlay functions
    func addDraw(forGeotification geotification: Geotification) {
        let marker = PlaceMarker(place: geotification)
        marker.title = geotification.title
        marker.snippet = geotification.identifier
        marker.tracksInfoWindowChanges = true
        marker.map = self.mapView
        markers.append(marker)
        let circle = PlaceCircle(place: geotification)
        circle.map = mapView
        circles.append(circle)
        
    }
    
    func removeDraw(forGeotification identifier: String) {
        var p = 0
        for marker in self.markers{
            if(marker.place.identifier == identifier){
                marker.map = nil
                circles[p].map = nil
                markers.remove(at: p)
                circles.remove(at: p)
                break
            }
            p = p+1
        }
    }
    
    private func setDrawYellow(identifier: String){
        var p = 0
        for marker in markers{
            print(marker.place.identifier)
            print(identifier)
            if(marker.place.identifier == identifier){
                print("yellow")
                marker.icon = GMSMarker.markerImage(with: .yellow)
                marker.map = mapView
                circles[p].fillColor = .blueMerciAlpha
                circles[p].strokeColor = .blueMerci
                circles[p].map = mapView
            }
            p = p+1
        }
        
    }
    
    private func resetDraw(identifier: String){
        var p = 0
        for marker in markers{
            if(marker.place.identifier == identifier){
                marker.icon = GMSMarker.markerImage(with: .red)
                marker.map = mapView
                circles[p].fillColor = .redAlpha
                circles[p].strokeColor = .red
                circles[p].map = mapView
                
            }
            p = p+1
        }
    }
    
    private func setupViews(){
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
    }
    
    
}



// MARK: - CLLocationManagerDelegate
extension MapGeofireViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    private func setUserPositionToFirestore(position: CLLocation){
        let geoPoint = GeoPoint(latitude: position.coordinate.latitude, longitude: position.coordinate.longitude)
        self.db.collection("users").document(self.uid).setData([
            "gpsLastLocation": geoPoint,
            ] as [String : Any], merge: true, completion: { err in
                if let err = err {
                    print("Failed store gpsLastLocation: \(err)")
                } else {
                    print("Succeed store gpsLastLocation")
                }
        })
    }
    
    private func setUserPositionGeoFire(position : CLLocation){
        self.geoFireLocationUsers?.setLocation(position, forKey: self.uid) { (error) in
            if (error != nil) {
                print("An error occured: \(error?.localizedDescription ?? "none")")
            } else {
                print("Saved location successfully!")
                self.getNearbyPlaces(position: position)
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        print("Location updated: \(location)")
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // Put position in Server
        if(self.justOnceBool){
            self.justOnceBool = false
            setUserPositionToFirestore(position: location)
            setUserPositionGeoFire(position: location)
        }
        // Put position in Server
        
        locationManager.stopUpdatingLocation()
    }
}
