//
//  MapViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 05/07/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import MapKit
import AVFoundation
import GooglePlaces

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    

    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        return mapView
    }()
    
    
    var placesClient: GMSPlacesClient!

    var db: Firestore!
    let locationManager = CLLocationManager()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        initMap()
        initGeofence()
        view.backgroundColor = .white
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print(location.coordinate)
            
        }
        manager.stopUpdatingLocation()

    }
    
    func initMap(){
        view.addSubview(mapView)
        mapView.delegate = self
        NSLayoutConstraint.activate([
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor)

            ])
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.allowsBackgroundLocationUpdates = true
        }
        
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)

        let current_location = locationManager.location?.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        if(current_location != nil){
            let region = MKCoordinateRegion(center: current_location!, span: span)
            mapView.setRegion(region, animated: true)
        }

    }
    
    func initGeofence(){
        // Specify the place data types to return.
        print("let's get fields!")
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!

        placesClient?.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
            (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }

            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList {
                    let place = likelihood.place
                    print("Current Place name \(String(describing: place.name)) at likelihood \(likelihood.likelihood)")
                    print("Current PlaceID \(String(describing: place.placeID))")
                }
            }

        })

        // We will get all the documents here and display circle around them
//        let geopoint = access.center
//        let latitude = geopoint?.latitude
//        let longitude = geopoint?.longitude
//        let radius = Double(value["radius"] as? String ?? "none")
//        self.addCircleMap(location: CLLocation(latitude: latitude!, longitude: longitude!), radius: radius!)
//        let location = CLLocationCoordinate2DMake(latitude!, longitude!)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = accessName
//        self.mapView.addAnnotation(annotation)
//        //----- listener Geofence
//        let center = CLLocation(latitude: latitude!, longitude: longitude!)
//        let circleQuery = self.geoFire?.query(at: center, withRadius: radius!/1000) //1 = 1000m
//        self.circleQueryArray.append(circleQuery!)
    }
    
    func resetMap(){
        let allOverlay = self.mapView.overlays
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.removeOverlays(allOverlay)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    
    func addCircleMap(location: CLLocation, radius: Double){
        let circle = MKCircle(center: location.coordinate, radius: radius) // 1 = 1 metre
        self.mapView.addOverlay(circle)
        
    }
}
