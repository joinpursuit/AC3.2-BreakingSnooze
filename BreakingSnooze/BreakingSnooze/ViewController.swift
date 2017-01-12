//
//  ViewController.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/9/17.
//  Copyright © 2017 C4Q. All rights reserved.
//
//APIKEY = 817c2d1fcd584b7ca26af5888e55bfd2
//APIKEYFORRADIO = ed4616717617f6e9d090f88c8f
import Foundation
import UIKit
import CoreData
import CoreLocation


fileprivate var sourcesURL = "https://newsapi.org/v1/sources"
fileprivate let reuseIdentifer = "Top Stories Cell"


class ViewController: UIViewController, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionsImageView: UIImageView!
    @IBOutlet weak var verticalLineView: UIView!
    @IBOutlet weak var degreeIconView: UIImageView!
    @IBOutlet weak var listeningToLabel: UILabel!
    @IBOutlet weak var radioStationNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var breakingSnoozeBackgroundView: UIView!
    
    @IBOutlet weak var breakingNewsLabel: UILabel!
    @IBOutlet weak var localNewsTableView: UITableView!
    
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    private var controller: NSFetchedResultsController<NewsSource>!
    
    let locationManager: CLLocationManager = {
        let locMan = CLLocationManager()
        
        locMan.desiredAccuracy = 250.0
        locMan.distanceFilter = 250.0
        
        return locMan
    }()
    var currentWeather: [Weather] = []

    lazy var allArticles: [NewsArticles] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        localNewsTableView.delegate = self
        localNewsTableView.dataSource = self
        initializeFetchedResultsController()
        getSources()
        locationManager.delegate = self
        permission()
        whiteTextShadow()
        setUpButtonImages()
        getArticlesFromSources()
    }
    
    

    func setUpButtonImages() {
        let playPauseImage = UIImage(named: "play_button")
        playPauseButton.setBackgroundImage(playPauseImage, for: UIControlState.normal)

        let settingsImage = UIImage(named: "settings_Icon")
        settingsButton.setBackgroundImage(settingsImage, for: UIControlState.normal)
        
        let degreeImage = UIImage(named: "degree_Icon_1x")
        degreeIconView.image = degreeImage
    }
    
    func whiteTextShadow() {
        let _ = [
            temperatureLabel,
            locationLabel,
            conditionsImageView,
            verticalLineView,
            degreeIconView,
            listeningToLabel,
            radioStationNameLabel,
            breakingSnoozeBackgroundView
        ].map { $0.layer.shadowOffset = CGSize(width: 0, height: 0) }
        
        let _ = [
            temperatureLabel,
            locationLabel,
            conditionsImageView,
            verticalLineView,
            degreeIconView,
            listeningToLabel,
            radioStationNameLabel
        ].map { $0.layer.shadowOpacity = 0.50 }
        
        breakingSnoozeBackgroundView.layer.shadowOpacity = 0.10

        let _ = [
            temperatureLabel,
            locationLabel,
            conditionsImageView,
            verticalLineView,
            degreeIconView,
            listeningToLabel,
            radioStationNameLabel,
            breakingSnoozeBackgroundView
            ].map { $0.layer.shadowRadius = 6 }
        

    }
    
    //MARK: - Load data from API
    
    func loadData(endPoint: String) {
        APIRequestManager.manager.getPOD(endPoint: endPoint) { (data: Data?) in
            if data != nil {
                
                if let new = Weather.getData(from: data!) {
                    self.currentWeather = new
                    dump(self.currentWeather)
                }
                
                DispatchQueue.main.async {
                    let imageName = self.currentWeather[0].icon
                    let image = UIImage(named: imageName)
                    self.conditionsImageView.image =  image

                    self.temperatureLabel.text = String(Int(self.currentWeather[0].temp.rounded()))
                    self.locationLabel.text = "\(self.currentWeather[0].name), \(self.currentWeather[0].country)"
                    print("\(self.currentWeather[0].name), \n\(self.currentWeather[0].country)")
                    self.view.reloadInputViews()
                }
                
            }
        }
        
    }
    
    func getSources() {
        APIManager.shared.getData(urlString: sourcesURL)
        { (data: Data?) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options:[]) {
                    if let wholeDict = jsonData as? [String:Any],
                        let rawSources = wholeDict["sources"] as? [[String:Any]] {
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let pc = appDelegate.persistentContainer
                        pc.performBackgroundTask { (context: NSManagedObjectContext) in
                            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                            
                            // Comment #2
                            // insert your core data objects here
                            for rawSource in rawSources {
                                let newsSource = NewsSource(context: context)
                                newsSource.parseJson(from: rawSource)
                            }
                            do {
                                try context.save()
                            }
                            catch let error {
                                print(error)
                            }
                            
                            DispatchQueue.main.async {
                                self.initializeFetchedResultsController()
                                //self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    func initializeFetchedResultsController() {
        let request: NSFetchRequest<NewsSource> = NewsSource.fetchRequest()
        let sort = NSSortDescriptor(key: "sourceName", ascending: true)
        request.sortDescriptors = [sort]
        
        self.controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
            // self.tableView.reloadData()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
    }
    
<<<<<<< HEAD
    func getArticlesFromSources() {
        
        APIRequestManager.manager.getPOD(endPoint: AssociatedPress) { (data: Data?) in
            if data != nil {
                
                if let article = NewsArticles.getData(from: data!) {
                    self.allArticles = article
                    
                }
                
                DispatchQueue.main.async {
                 self.localNewsTableView.reloadData()
                }
                
            }
        }
        
    }
=======
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
>>>>>>> aadfc6a91fa832e93c7d2f7e98219938ad2e39c3
    //MARK: - Core Location
    
    func permission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("ALL good")
        case .denied, .restricted:
            print("NOPE")
            guard let validSettingsURL = URL(string: UIApplicationOpenSettingsURLString) else {return}
            UIApplication.shared.open(validSettingsURL, options: [:], completionHandler: nil)
        case .notDetermined:
            print("IDK")
            locationManager.requestAlwaysAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("All good")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("NOPE")
            manager.stopUpdatingLocation()
        case .notDetermined:
            print("IDK")
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations updated")
        guard let validLocation = locations.last else {return}
        let latCoordinate = validLocation.coordinate.latitude
        let longCoordinate = validLocation.coordinate.longitude
        let latCoord =  String(format: "%0.4f", latCoordinate )
        let longCoord = String(format: "%0.4f", longCoordinate )
        
        
        loadData(endPoint: "http://api.openweathermap.org/data/2.5/weather?lat=\(latCoord)&lon=\(longCoord)&appid=22b1e9d953bb8df3bcdf747f549be645&units=imperial")
        
        locationManager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
    
    //MARK: // -Helper Functions
    
    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) -> String {
        let article = controller.object(at: indexPath)
        let name = article.sourceID
        return name ?? "associated-press"
    }
    
    func randomNewSource() -> NSFetchedResultsSectionInfo {
        guard let section = controller.sections else {return NSFetchedResultsSectionInfo.self as! NSFetchedResultsSectionInfo}
        let random = section[Int(arc4random_uniform(UInt32(68)))]
        return random
    }
    
    func getArticlesFromSources() {
        let random = controller.fetchedObjects?[Int(arc4random_uniform(UInt32(69)))].sourceID
        
        let endpoint = "https://newsapi.org/v1/articles?source=\(random!)&sortBy=top&apiKey=df4c5752e0f5490490473486e24881ef"
        print("****************\(endpoint)************")
        APIRequestManager.manager.getPOD(endPoint: endpoint) { (data: Data?) in
            if data != nil {
                
                if let article = NewsArticles.getData(from: data!) {
                    self.allArticles = article
                    
                }
                
                DispatchQueue.main.async {
                    self.localNewsTableView.reloadData()
                    print("***********Reload or Nah*************")
                }
                
            }
        }
        
    }


    //MARK: // -Table View Delegate
    
     func numberOfSections(in tableView: UITableView) -> Int {
//        guard let sections = controller.sections else {
//            print("No sections in fetchedResultsController")
//            return 0
//        }
//        
//        return sections.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let sections = controller.sections else {
//            fatalError("No sections in fetchedResultsController")
//        }
//        let sectionInfo = sections[section]
//        
//        return sectionInfo.numberOfObjects
        return allArticles.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        
//        let article = controller.object(at: indexPath)
//        cell.textLabel?.text = article.sourceName
        let article = allArticles[indexPath.row]
        cell.textLabel?.text = article.title
      
        return cell
    }
}

