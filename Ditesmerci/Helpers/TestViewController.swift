//
//  TestViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 07/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


class TestViewController : UIViewController {
    
    private let locationManager = CLLocationManager()
    private let radiusCircle: CLLocationDistance = 15
    var geotifications: [Geotification] = []
    var markers = [PlaceMarker]()
    var circles = [PlaceCircle]()
    var placesClient = GMSPlacesClient()
    
    
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update Location", for: .normal)
        button.addTarget(self, action: #selector(handleUpdateLocation), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        return mapView
    }()
    
    
    @objc private func handleUpdateLocation(){
        locationManager.startUpdatingLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLocationManager()
    }
    
    private func getNearbyPlaces(){
        removeAllGeotifications()
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
            (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                var n = 0
                for likelihood in placeLikelihoodList {
                    n = n + 1
                    let place = likelihood.place
                    let center = place.coordinate
                    let placeID = place.placeID ?? "none"
                    let name = place.name ?? "none"
                    print("\(n) PlaceID: \(placeID) at center \(center)")
                    print("\(n) name: \(name) at likelihood \(likelihood.likelihood)")
                    self.addGeotification(coordinate: center, radius: self.radiusCircle, identifier: placeID, note: name, eventType: Geotification.EventType.onEntry)
                }
            }
        })
    }
    
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //loadAllGeotifications()
    }
    
    
    
    func addGeotification(coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: Geotification.EventType) {
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let geotification = Geotification(coordinate: coordinate, radius: clampedRadius,
                                          identifier: identifier, note: note, eventType: eventType)
        add(geotification)
        startMonitoring(geotification: geotification)
        saveAllGeotifications()
    }
    
    // MARK: Functions that update the model/associated views with geotification changes
    func add(_ geotification: Geotification) {
        geotifications.append(geotification)
        addDraw(forGeotification: geotification)
    }
    
    func remove(_ geotification: Geotification) {
        guard let index = geotifications.firstIndex(of: geotification) else { return }
        geotifications.remove(at: index)
        removeDraw(forGeotification: geotification.identifier)
    }
    
    func removeAllGeotifications(){
        stopAllMonitoring()
        geotifications.removeAll()
        mapView.clear()
    }
    
    
    // MARK: Map overlay functions
    func addDraw(forGeotification geotification: Geotification) {
        let marker = PlaceMarker(place: geotification)
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
    
    
    
    
    // MARK: Loading and saving functions
    func loadAllGeotifications() {
        geotifications.removeAll()
        let allGeotifications = Geotification.allGeotifications()
        allGeotifications.forEach { add($0) }
    }
    
    func saveAllGeotifications() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(geotifications)
            UserDefaults.standard.set(data, forKey: PreferencesKeys.savedItems)
        } catch {
            print("error encoding geotifications")
        }
    }
    
    
    func startMonitoring(geotification: Geotification) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            self.displayAlertErrorUI(title: "Error", message: "Geofencing is not supported on this device!", answer: "OK")
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            let message = """
      Dites Merci a besoin de la localisation de votre appareil afin de fonctionner correctement.
      """
            
            self.displayAlertErrorUI(title: "Warning", message: message, answer: "OK")
        }
        let fenceRegion = region(with: geotification)
        locationManager.startMonitoring(for: fenceRegion)
    }
    
    func region(with geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate,
                                      radius: geotification.radius,
                                      identifier: geotification.identifier)
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion,
                circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func stopAllMonitoring(){
        for region in locationManager.monitoredRegions{
            guard let circularRegion = region as? CLCircularRegion else { continue }
            locationManager.stopMonitoring(for: circularRegion)
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
        
        mapView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.widthAnchor.constraint(equalToConstant: 100),
            ])
        
    }
    
    
    
    
    
    
    
}





// MARK: - CLLocationManagerDelegate
extension TestViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        print("Location updated: \(location)")
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
        
        getNearbyPlaces()
    }
    
    
    internal func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
        // Remove draw of failed geofence
        removeDraw(forGeotification: region!.identifier)
        
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
}










//class GooglePlace {
//    let name: String
//    let address: String
//    let coordinate: CLLocationCoordinate2D
//    let placeID: String
//
//    init(dictionary: [String: Any])
//    {
//        let json = JSON(dictionary)
//        name = json["name"].stringValue
//        address = json["vicinity"].stringValue
//        placeID = json["place_id"].stringValue
//
//        let lat = json["geometry"]["location"]["lat"].doubleValue as CLLocationDegrees
//        let lng = json["geometry"]["location"]["lng"].doubleValue as CLLocationDegrees
//        coordinate = CLLocationCoordinate2DMake(lat, lng)
//
//    }
//}




//typealias PlacesCompletion = ([GooglePlace]) -> Void
//class GoogleDataProvider {
//    let API_key_google_maps = "AIzaSyBSslT3Zm9HpxaABQjE3Fg0Kysv6ic1HLs"
//    private var placesTask: URLSessionDataTask?
//    private var session: URLSession {
//        return URLSession.shared
//    }
//
//    func fetchPlacesNearCoordinate(_ coordinate: CLLocationCoordinate2D, searchRadius: Double, completion: @escaping PlacesCompletion) -> Void {
//        print("going to fetchPlacesNearCoordinate")
//        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(searchRadius)&rankby=prominence&sensor=true&key=\(API_key_google_maps)"
//
//        guard let url = URL(string: urlString) else {
//            completion([])
//            return
//        }
//        print("je suis la 1")
//
//        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
//            task.cancel()
//        }
//        print("je suis la 2")
//
//        DispatchQueue.main.async {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
//        print("je suis la 3")
//
//        placesTask = session.dataTask(with: url) { data, response, error in
//            var placesArray: [GooglePlace] = []
//            defer {
//                DispatchQueue.main.async {
//                    print("je suis la 4")
//
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    completion(placesArray)
//                }
//            }
//            print("je suis la 5")
//
//            guard let data = data,
//                let json = try? JSON(data: data, options: .mutableContainers),
//                let results = json["results"].arrayObject as? [[String: Any]] else {
//                    return
//            }
//
//            print("je suis la 7")
//            print(results)
//            results.forEach {
//                print("je suis la 8")
//
//                let place = GooglePlace(dictionary: $0)
//                placesArray.append(place)
//            }
//        }
//        placesTask?.resume()
//    }
//}





