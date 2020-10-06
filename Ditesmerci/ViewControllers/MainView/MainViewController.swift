//
//  MainViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 11/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import GeoFire
import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDynamicLinks

extension MainViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class MainViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarDelegate {
    // Firebase
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var user: User?
    var uid: String?
    //var tabBar: TabBarController?
    
    
    // For DynamicLinks
    let domainURIPrefix = "https://ditesmerci.page.link"
    let scheme = "https"
    let host = "www.ditesmerci.com"
    let path = "/invite"
    let ditesMerciImage = "https://firebasestorage.googleapis.com/v0/b/ditesmerci-c006a.appspot.com/o/test%2Flogo%20dites%20merci.jpg?alt=media&token=6ea0e4b5-7ba6-4f62-ab87-9745265fe895"
    
    // Search
    let searchController = UISearchController(searchResultsController: nil)
    
    // GeoFire system
    let locationManager = CLLocationManager()
    let geofireRef = Database.database().reference()
    var geoFireCompanies: GeoFire?
    var geoFireLocationUser: GeoFire?
    var geoFireLocationUsersUID: GeoFire?
    let radiusScanner: CLLocationDistance = 100      // meters
    let radiusCircle: CLLocationDistance = 100           // meters
    var getNearbyPlacesQuery: GFCircleQuery?
    var circleQueriesPlaces = [GFCircleQuery]()
    var myCompanyQuery: GFCircleQuery?
    var justOnceBool = true
    var bool = false
    var p = 0
    // CollectionView
    private let companyCellId = "companyCellId"
    var companiesPlaceId = [String]() // values are unique
    var groups = [ExpandableEmployeesList]()
    var filteredEmployees = [ExpandableEmployeesList]()
    var selectedIndex = -1


    
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blueMerci
        refreshControl.attributedTitle = NSAttributedString(string: "Chargement des données...")
        
        return refreshControl
    }()

    lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ditesmerci")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var inviteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "invite")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInvite)))

        return imageView
    }()
    
    
    let indicationTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Retrouvez ici les professionnels que vous rencontrez"
        textView.textColor = .gray
        textView.backgroundColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.keyboardType = UIKeyboardType.alphabet
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.isSelectable = false
        textView.isHidden = false
        return textView
    }()
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        updateLocation()
        self.refreshControl.endRefreshing()
    }
    
    private func updateLocation(){
        justOnceBool = true
        p = 0
        selectedIndex = -1
        locationManager.startUpdatingLocation()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        user = auth.currentUser
        uid = user?.uid
        // Setup BackButton
        setupBackButton()
        if let uid = auth.currentUser?.uid {
            geoFireCompanies = GeoFire(firebaseRef: geofireRef.child("companies_geofire"))
            geoFireLocationUser = GeoFire(firebaseRef: geofireRef.child("users_location").child(uid))
            
            // Search
            setupSearchController()
            
            // Navigation Bar
            setupNavigationBar()
            
            // SetupViews
            setupViews()
            
            // CollectionView
            collectionView?.backgroundColor = UIColor.clear
            collectionView?.register(CompanyCell.self, forCellWithReuseIdentifier: companyCellId)
            collectionView?.refreshControl = refreshControl
            
            
            // Location Manager
            db.collection("users").document(uid).setData([
                "isPresent": false
            ], merge: true) { (error) in
                if let error = error {
                    print("failed to set isPresent false: \(error)")
                    return
                }
                print("succeed to set isPresent false")
                //self.setGeoFire()
                self.setupLocationManager()
                self.locationManager.startUpdatingLocation()

            }
            
            
            
      
        } else {
            let showCaseViewController = ShowcaseViewController()
            let nav = UINavigationController(rootViewController: showCaseViewController)
            nav.interactivePopGestureRecognizer?.isEnabled = true
            nav.setNavigationBarHidden(true, animated: false)
            self.present(nav, animated: false, completion: nil)
            return
        }

    }
    
    
    private func setupViews(){
        view.addSubview(indicationTextView)
        
        NSLayoutConstraint.activate([
            indicationTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicationTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicationTextView.heightAnchor.constraint(equalToConstant: 80),
            indicationTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            ])
        
    }
    
    
    private func setGeoFire(){
        let geoFire = GeoFire(firebaseRef: geofireRef.child("companies_geofire"))
        geoFire.setLocation(CLLocation(latitude: 41.9323247, longitude: 8.8363971), forKey: "ChIJhVulBAZn5kcRIbkbeto9tu8") { (error) in
            if let error = error {
                print(error)

            } else {
                print("SUCCESS")
            }
        
        }
        
        geoFire.setLocation(CLLocation(latitude: 41.9226189, longitude: 8.8410548), forKey: "ChIJ-6rPewJl5kcRMh3-RzGafYs") { (error) in
            if let error = error {
                print(error)

            } else {
                print("SUCCESS")
            }
            
        }
    }

    @objc private func handleInvite(){
        print("trying to open external apps")
        setupDynamicLink()
    }
    

    
    private func setupDynamicLink(){
        print("try to create share profil link")
        let alertController = UIAlertController(title: nil, message: "Patientez s'il vous plaît...\n\n", preferredStyle: .alert)
        self.displayWaitSpinner(alertController: alertController)
        guard let uid = auth.currentUser?.uid else {return}
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        let uidQueryItem = URLQueryItem(name: "uid", value: uid)
        components.queryItems = [uidQueryItem]
        
        guard let linkParameter = components.url else {return}
        
        print("I am sharing \(linkParameter.absoluteString)")
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: domainURIPrefix) else {
            print("couldn't create FDL components")
            return
        }
        if let myBundleId = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        // Temporarily use Google Photos
        shareLink.iOSParameters?.appStoreID = "962194608"
        let imageUrl = URL(fileURLWithPath: ditesMerciImage)
        // To have something more fancy than just lead to the appstore
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Soyez récompensé pour votre travail!"
        shareLink.socialMetaTagParameters?.descriptionText = "Un client a voulu vous remercier sur la plateforme 'Dites Merci'. Téléchargez l'application afin de recevoir son avis."
        shareLink.socialMetaTagParameters?.imageURL = imageUrl

        
        guard let longURL = shareLink.url else {return}
        print("the long dynamic link is \(longURL)")
        
        
        shareLink.shorten { [weak self] (url, warnings, error) in
            if let error = error {
                print("Got an error with dynamic link! \(error)")
                return
            }
            if let warnings = warnings {
                for warning in warnings {
                    print("FDL Warning : \(warning)")
                }
            }
            guard let url = url else {return}
            print("Short url to share : \(url.absoluteString)")
            let textToShare = "Un client est très satisfait de votre prestation et souhaite vous remercier. Cliquez sur le lien suivant afin de recevoir son avis."
            
            let objectsToShare: [Any] = [textToShare, url]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            alertController.dismiss(animated: true, completion: {
                self?.present(activityVC, animated: true, completion: nil)
            })

        }
    }
    
    private func TestSetlocationGeoFire(position : CLLocation, key: String){
        self.geoFireCompanies?.setLocation(position, forKey: key) { (error) in
            if (error != nil) {
                print("An error occured: \(error?.localizedDescription ?? "none")")
            } else {
                print("Saved test location successfully!")
                
            }
        }
    }
    

    
    // MARK: NavigationBar system
    func setupNavigationBar(){
        if let navControllerView = navigationController?.view {
            navControllerView.backgroundColor = .white
            navigationItem.titleView = bannerImageView
            if let bannerImage = bannerImageView.image {
                bannerImageView.image = bannerImage.resize(targetSize: CGSize(width: 150, height: 33))
            }
        }
    }
    

    
    
    // MARK: Search system
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredEmployees = groups.filter({( expandableEmployeesList : ExpandableEmployeesList) -> Bool in
            return (expandableEmployeesList.employeesList[0].jobCompanyName?.lowercased().contains(searchText.lowercased()))!
        })

        collectionView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    

    
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Entreprise"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
    }
    // MARK: END Search system
    

    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.activityType = CLActivityType.fitness
    }
    
    
    func removeGeoQueries(){
        getNearbyPlacesQuery?.removeAllObservers()
        for circleQuery in circleQueriesPlaces{
            circleQuery.removeAllObservers()
        }
        groups.removeAll()
        companiesPlaceId.removeAll()
        
    }
    
    
    private func setupGeofenceCurrentJob(){
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("users").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("failed to fetch current userinfo: \(error)")
                return
            }
            
            guard let document = documentSnapshot?.data() else {return}
            
            let userInfo = UserInfo(dictionary: document)
            
            
            if let jobGpsLocation = userInfo.jobGpsLocation, let isPro = userInfo.isPro {
                if isPro {
                    print("user pro")
                    let latitudeCompany = jobGpsLocation.latitude
                    let longitudeCompany = jobGpsLocation.longitude
                    
                    let center = CLLocation(latitude: latitudeCompany, longitude: longitudeCompany)
                    self.myCompanyQuery = self.geoFireLocationUser?.query(at: center, withRadius: 50 / 1000) //    meters/1000
                    
                    self.myCompanyQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
                        if let location = location, let key = key {
                            print("Key '\(key )' entered the search area and is at location '\(location )'")
                            print("User is inside his company")
                            self.setIsPresentToFirestore(isPresent: true)
                        }
                    })
                    self.myCompanyQuery?.observe(.keyExited, with: { (key: String!, location: CLLocation!) in
                        if let location = location, let key = key {
                            print("Key '\(key )' exited the search area and is at location '\(location )'")
                            print("User has left his company")
                            self.setIsPresentToFirestore(isPresent: false)
                        }
                        
                    })
                } else {
                    print("user not pro")
                }
                
            }
        }
    }
    
    private func setIsPresentToFirestore(isPresent: Bool) {
        db.collection("users").document(uid!).setData([
            "isPresent": isPresent,
            "timestampPresent": FieldValue.serverTimestamp()
        ], merge: true) { (error) in
            if let error = error {
                print("failed to set isPresent state: \(error)")
                return
            }
            print("success to store isPresent state")
        }
    }
    

    
    private func getNearbyPlaces(position: CLLocation){
        removeGeoQueries()
        let coordinateUser = position.coordinate
        let latitudeUser = coordinateUser.latitude
        let longitudeUser = coordinateUser.longitude
        
        let center = CLLocation(latitude: latitudeUser, longitude: longitudeUser)
        getNearbyPlacesQuery = geoFireCompanies?.query(at: center, withRadius: radiusScanner / 1000) //    meters/1000
        
        getNearbyPlacesQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            print("Key '\(key ?? "none")' entered the search area and is at location '\(location ?? GeoPoint(latitude: 1, longitude: 1))'")
            print("This place is 'visible' by the user")
            self.queryGeofences(location: location, identifier: key)
        })
        getNearbyPlacesQuery?.observe(.keyExited, with: { (key: String!, location: CLLocation!) in
            print("Key '\(key ?? "none")' exited the search area and is at location '\(location ?? GeoPoint(latitude: 1, longitude: 1))'")
            print("This place is not 'visible' by the user anymore")
            //self.updateGeofences()
        })
        
        

    }
    
    private func queryGeofences(location: CLLocation, identifier: String){
        let center = location
        if let circleQuery = self.geoFireLocationUser?.query(at: center, withRadius: radiusCircle / 1000){
            
            self.circleQueriesPlaces.append(circleQuery)
            
            circleQuery.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
                print("Key '\(key ?? "none")' entered the search area and is at location '\(location ?? GeoPoint(latitude: 1, longitude: 1))'")
                print("User enter in a place")
                if self.p < 3 {
                    self.displayEmployees(identifier: identifier)
                }
                self.p = self.p + 1
            
            })
            circleQuery.observe(.keyExited) { (key: String!, location: CLLocation!) in
                print("Key '\(key ?? "none")' exited the search area and is at location '\(location ?? GeoPoint(latitude: 1, longitude: 1))'")
                print("User exit the place")
               // self.updateGeofences()
            }
        }
    }
    
    
    private func displayEmployees(identifier: String){
        print("try to display employees")
            db.collection("users")
                .whereField("jobPlaceId", isEqualTo: identifier)
                .whereField("isPresent", isEqualTo: true)
                .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let documents = querySnapshot?.documents else {
                    return
                }
                
                var employeesList = [UserInfo]()
                var employeesUid = [String]()
                
                for document in documents {
                    let employeeInfo = UserInfo(dictionary: document.data())
                    employeeInfo.isHistoric = false
                    employeesList.append(employeeInfo)
                    if let employeeUid = employeeInfo.uid {
                        employeesUid.append(employeeUid)
                    }
                }
                    
                if employeesList.count > 0 {
                    self.indicationTextView.isHidden = true

                    // Pour supprimer les élements qui se répètent avec l'historiques
//                    if self.companiesPlaceId.contains(identifier){
//                        var p = 0
//                        for placeId in self.companiesPlaceId {
//                            if identifier == placeId {
//                                self.groups.remove(at: p)
//                                self.companiesPlaceId.remove(at: p)
//                            }
//                            p = p + 1
//                        }
//                    }
                    let expandableEmployeesList = ExpandableEmployeesList(isExpanded: true, employeesList: employeesList)
                    self.groups.insert(expandableEmployeesList, at: 0)
                    self.companiesPlaceId.append(identifier)
                    if let jobCompanyName = employeesList[0].jobCompanyName {
                        self.setPlaceInfoVisited(placeId: identifier, employeesPresentUid: employeesUid, companyName: jobCompanyName)
                    }
                }
                    
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
        }
    }

    
    private func getVisitedPlaces(){
        print("try to get visited places")
        
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("users").document(uid).collection("visited").order(by: "timestampVisited", descending: false).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error get visitedInfo : \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {return}
    
        
            for document in documents {
                let placeId = document.documentID
                let visitedInfo = VisitedInfo(dictionary: document.data())
//                if self.companiesPlaceId.contains(placeId) {
//                    print("the list already contains this placeId : \(placeId)")
//                    return
//                }
                guard let timestampVisited = visitedInfo.timestampVisited else {return}
                guard let employeesPresentUid = visitedInfo.employeesPresentUid else {return}
                print("employeesPresentUid : \(employeesPresentUid)")
                let dateVisited = timestampVisited.dateValue()
                
                let difference = Date().minutes(from: dateVisited)
                print("difference: \(difference)")
                if difference > 1439 { // number of minutes in 24h
                    self.deleteVisitedDocument(placeId: placeId)
                    continue
                }
                
                self.getPresentVisitedEmployees(jobPlaceId: placeId, timestampVisited: timestampVisited, employeesPresentUid: employeesPresentUid)
                
            }
        }
    }
    
    
    private func getPresentVisitedEmployees(jobPlaceId: String, timestampVisited: Timestamp, employeesPresentUid: [String] ){
        db.collection("users").whereField("jobPlaceId", isEqualTo: jobPlaceId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("failed to get present employees visited with jobPlaceId: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {return}
            
            var employeesList = [UserInfo]()
            for document in documents {
                let employeeVisited = UserInfo(dictionary: document.data())
                employeeVisited.isHistoric = true
                employeeVisited.timestampVisited = timestampVisited
                guard let employeeUid = employeeVisited.uid else {return}
                if employeesPresentUid.contains(employeeUid) {
                    employeesList.append(employeeVisited)
                }
            }
            
            if employeesList.count > 0 {
                self.indicationTextView.isHidden = true
                let expandableEmployeesList = ExpandableEmployeesList(isExpanded: false, employeesList: employeesList)
                self.groups.append(expandableEmployeesList)
                self.companiesPlaceId.append(jobPlaceId)
            }
            
            DispatchQueue.main.async(execute: {
                self.collectionView?.reloadData()
            })
        }
        
    }

    
    private func deleteVisitedDocument(placeId: String){
        guard let uid = auth.currentUser?.uid else {return}
        db.collection("users").document(uid).collection("visited").document(placeId).delete { (error) in
            if let error = error {
                print("failed to delete document visited: \(error)")
            } else {
                print("succeed to delete document visited")
            }
        }
    }

    
    private func setPlaceInfoVisited(placeId: String, employeesPresentUid: [String], companyName: String){
        print("try to set place visited info in Firestore")
        if let uid = auth.currentUser?.uid{
            self.db.collection("users").document(uid).collection("visited").document(placeId).setData([
                "companyName": companyName,
                "employeesPresentUid": employeesPresentUid,
                "timestampVisited":  FieldValue.serverTimestamp()
                ] as [String : Any], merge: true, completion: { err in
                    if let err = err {
                        print("Failed store userInfo: \(err)")
                        
                    } else {
                        print("Succeed store visitedInfo")

                    }
            })
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: companyCellId, for: indexPath) as! CompanyCell
        if (isFiltering()) {
            cell.expandableEmployeesList = filteredEmployees[indexPath.item]
            cell.delegate = self
            return cell
        }
        let expandableEmployeesList = groups[indexPath.item]
        
        cell.expandableEmployeesList = expandableEmployeesList
        cell.delegate = self
        
        let employeeList = groups[indexPath.item].employeesList

        if employeeList.count != 0 && employeeList[0].isHistoric == true {
            if let timestampVisited = employeeList[0].timestampVisited {
                let date = timestampVisited.dateValue()
                let text = date.timeAgoDisplay()
                //cell.isExpanded = false
                print("section : \(indexPath.section)")
                cell.timestampLabel.text = text
                return cell
            }
        }
        
        cell.timestampLabel.text = ""

        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredEmployees.count
        }
        let count = companiesPlaceId.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.cellForItem(at: indexPath) as? CompanyCell
        let index = indexPath.item
        let isExpanded = groups[index].isExpanded
        if (index == 0 && groups[0].employeesList.count > 6){
            let size: CGSize = CGSize(width: view.frame.width, height: 170*2)
            return size
        } else if (isExpanded)  {
            let size: CGSize = CGSize(width: view.frame.width, height: 200)
            cell?.employeeCollectionView.isHidden = false
            cell?.pageControl.isHidden = false
            return size
        } else {
            let size: CGSize = CGSize(width: view.frame.width, height: 60)
            cell?.employeeCollectionView.isHidden = true
            cell?.pageControl.isHidden = true
            return size
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("try to expandable the list")
        let item = indexPath.item

        if let isHistoric = self.groups[item].employeesList.first?.isHistoric {
            if isHistoric {
                let isExpanded = groups[item].isExpanded
                groups[item].isExpanded = !isExpanded
                print(item)
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    
}

// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        print("Location updated: \(location)")
        
        
        // Put position in Server
        if(self.justOnceBool){
            justOnceBool = false
            setUserPositionToFirestore(position: location)
            setUserPositionGeoFire(position: location)
        }
        
        // Stop Update Location Manager
        locationManager.stopUpdatingLocation()
    }
    
    
    private func setUserPositionToFirestore(position: CLLocation){
        let geoPoint = GeoPoint(latitude: position.coordinate.latitude, longitude: position.coordinate.longitude)
        if let uid = self.uid {
            self.db.collection("users").document(uid).setData([
                "gpsLastLocation": geoPoint,
                ] as [String : Any], merge: true, completion: { err in
                    if let err = err {
                        print("Failed store gpsLastLocation: \(err)")
                    } else {
                        print("Succeed store gpsLastLocation")
                    }
            })
        }
    }
    
    private func setUserPositionGeoFire(position : CLLocation){
        self.geoFireLocationUser?.setLocation(position, forKey: "position") { (error) in
            if (error != nil) {
                print("An error occured: \(error?.localizedDescription ?? "none")")
            } else {
                print("Saved location successfully!")
                self.getNearbyPlaces(position: position)
                self.getVisitedPlaces()
                self.setupGeofenceCurrentJob()
            }
        }
    }
}


