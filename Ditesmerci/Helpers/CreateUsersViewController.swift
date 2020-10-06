//
//  CreateUsersViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 27/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GeoFire

class CreateUsersViewController: UIViewController {
    
    var db = Firestore.firestore()
    let geofireRef = Database.database().reference()
    var geoFire: GeoFire?
    var coordinate: GeoPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blueMerci
        setupFirebase()
        setPlaceIdGeoFire()
        
        //batchUsersCreation()

    }
    
    
    private func setPlaceIdGeoFire(){
        geoFire?.setLocation(CLLocation(latitude: 48.990031, longitude: 2.235827), forKey: "ChIJ3QW3M4Rf5kcRikQCxauuGBM") { (error) in
            if let error = error {
                print("error to set GeoFire placeId: \(error)")

            } else {
                print("success to set GeoFire placeId")
            }
            
        }
    }
    
    private func setupFirebase(){
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        settings.isPersistenceEnabled = false
        db.settings = settings
        
        geoFire = GeoFire(firebaseRef: geofireRef.child("companies_geofire"))

    }
    
    private func batchUsersCreation(){
        let batch = self.db.batch()
        let geopoint = GeoPoint(latitude: 1, longitude: 1)
        let geopointJob = GeoPoint(latitude: 48.990031, longitude: 2.235827)
        let timestamp = FieldValue.serverTimestamp()

        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Julien", firstNameLowercase: "julien", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Ahmed", firstNameLowercase: "ahmed", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Nadia", firstNameLowercase: "nadia", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)

        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Elisabeth", firstNameLowercase: "elisabeth", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Corine", firstNameLowercase: "corine", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Sheena", firstNameLowercase: "sheena", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Madgar", firstNameLowercase: "madgar", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Benjamin", firstNameLowercase: "benjamin", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Idriss", firstNameLowercase: "idriss", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Stephane", firstNameLowercase: "stephane", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Melina", firstNameLowercase: "melina", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Christopher", firstNameLowercase: "christopher", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        createUser(batch: batch, email: "fakeaccount@test.com", firstName: "Inès", firstNameLowercase: "inès", gpsLastLocation: geopoint, isConnected: true, isPresent: true, isPro: true, isShowcase: false, job: "Ingénieur bâtiment", jobCityAddress: "Franconville", jobCompanyName: "Fake Leroy Merlin - Cours des Matériaux", jobFormattedAddress: "17 rue René Joly, 95130 Franconville", jobGpsLocation: geopointJob, jobGpsRadius: "30", jobNumberAddress: "17", jobPlaceId: "ChIJ3QW3M4Rf5kcRikQCxauuGBM", jobPostalCodeAddress: "95130", jobRoadAddress: "rue Renié Joly", jobSector: "home_goods_store", lastName: "Test", lastNameLowercase: "test", phoneNumber: "+33686662445", profileImageUrl: "none", profileImageUrlThumbnail: "none", reviewNumber: 0, thanks: 0, timestamp: timestamp, timestampCreationAccount: timestamp, timestampLastGpsDetection: timestamp, timestampPresent: timestamp)
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
                self.view.backgroundColor = .red

            } else {
                print("Batch write succeeded.")
                self.view.backgroundColor = .green

            }
        }
    }
    
    private func createUser(batch: WriteBatch, email: String, firstName: String, firstNameLowercase: String, gpsLastLocation: GeoPoint, isConnected: Bool, isPresent: Bool, isPro: Bool, isShowcase: Bool, job: String,
                             jobCityAddress: String, jobCompanyName: String, jobFormattedAddress: String, jobGpsLocation: GeoPoint, jobGpsRadius: String, jobNumberAddress: String,
                             jobPlaceId: String, jobPostalCodeAddress: String, jobRoadAddress: String, jobSector: String, lastName: String, lastNameLowercase: String, phoneNumber: String,
                             profileImageUrl: String, profileImageUrlThumbnail: String, reviewNumber: Int, thanks: Int, timestamp: FieldValue, timestampCreationAccount: FieldValue, timestampLastGpsDetection: FieldValue, timestampPresent: FieldValue){
        let uuid = UUID().uuidString
        let ref = self.db.collection("users").document(uuid)
        batch.setData([
            "email":  email,
            "firstName": firstName,
            "firstNameLowercase": firstNameLowercase,
            "gpsLastLocation": gpsLastLocation,
            "isConnected": isConnected,
            "isPresent": isPresent,
            "isPro": isPro,
            "isShowcase": isShowcase,
            "job": job,
            "jobCityAddress": jobCityAddress,
            "jobCompanyName": jobCompanyName,
            "jobFormattedAddress": jobFormattedAddress,
            "jobGpsLocation": jobGpsLocation,
            "jobGpsRadius": jobGpsRadius,
            "jobNumberAddress": jobNumberAddress,
            "jobPlaceId": jobPlaceId,
            "jobPostalCodeAddress": jobPostalCodeAddress,
            "jobRoadAddress": jobRoadAddress,
            "jobSector": jobSector,
            "lastName": lastName,
            "lastNameLowercase": lastNameLowercase,
            "notificationTokens": Messaging.messaging().fcmToken ?? "none",
            "phoneNumber": phoneNumber,
            "profileImageUrl": profileImageUrl,
            "profileImageUrlThumbnail": profileImageUrlThumbnail,
            "reviewNumber": reviewNumber,
            "thanks": thanks,
            "timestamp": timestamp,
            "timestampCreationAccount": timestampCreationAccount,
            "timestampLastGpsDetection": timestampLastGpsDetection,
            "timestampPresent": timestampPresent,
            "uid": uuid,
            ] as [String : Any], forDocument: ref, merge: true)
        
        
//        self.db.collection("users").document(uid).setData([
//        "email":  email,
//        "firstName": firstName,
//        "firstNameLowercase": firstNameLowercase,
//        "gpsLastLocation": gpsLastLocation,
//        "isConnected": isConnected,
//        "isPresent": isPresent,
//        "isPro": isPro,
//        "isShowcase": isShowcase,
//        "job": job,
//        "jobCityAddress": jobCityAddress,
//        "jobCompanyName": jobCompanyName,
//        "jobFormattedAddress": jobFormattedAddress,
//        "jobGpsLocation": jobGpsLocation,
//        "jobGpsRadius": jobGpsRadius,
//        "jobNumberAddress": jobNumberAddress,
//        "jobPlaceId": jobPlaceId,
//        "jobPostalCodeAddress": jobPostalCodeAddress,
//        "jobRoadAddress": jobRoadAddress,
//        "jobSector": jobSector,
//        "lastName": lastName,
//        "lastNameLowercase": lastNameLowercase,
//        "notificationTokens": Messaging.messaging().fcmToken ?? "none",
//        "phoneNumber": phoneNumber,
//        "profileImageUrl": profileImageUrl,
//        "profileImageUrlThumbnail": profileImageUrlThumbnail,
//        "reviewNumber": reviewNumber,
//        "thanks": thanks,
//        "timestamp": timestamp,
//        "timestampCreationAccount": timestampCreationAccount,
//        "timestampLastGpsDetection": timestampLastGpsDetection,
//        "timestampPresent": timestampPresent,
//        "uid": uid,
//            ] as [String : Any], merge: true, completion: { err in
//                if let err = err {
//                    print("Failed store userInfo: \(err)")
//                    self.view.backgroundColor = .red
//                } else {
//                    print("Succeed store userInfo")
//                    self.view.backgroundColor = .green
//                }
//        })
        
    }
}


