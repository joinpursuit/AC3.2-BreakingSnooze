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
    
    //MARK: \\ -Outlets
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
    
    
    //MARK: - Properties
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
    let sources = ["associated-press", "bb-news", "bloomberg", "buisness-insider", "buzzfeed"]
     let randomNum = Int(arc4random_uniform(UInt32(4)))
    
    
    
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
        self.breakingNewsLabel.text = "Todays Breaking Snooze \n courtesy of \(sources[randomNum])"
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
            print("All Good")
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
            manager.startUpdatingLocation()
        case .denied, .restricted:
            manager.stopUpdatingLocation()
        case .notDetermined:
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
    
    func randomNewSource() -> NSFetchedResultsSectionInfo {
        guard let section = controller.sections else {return NSFetchedResultsSectionInfo.self as! NSFetchedResultsSectionInfo}
        let random = section[Int(arc4random_uniform(UInt32(68)))]
        return random
    }
    
    func getArticlesFromSources() {
//        let random = controller.fetchedObjects?[Int(arc4random_uniform(UInt32(69)))].sourceID
        let random = sources[randomNum]
        let endpoint = "https://newsapi.org/v1/articles?source=associated-press&sortBy=top&apiKey=df4c5752e0f5490490473486e24881ef"
        print("****************\(endpoint)************")
        APIRequestManager.manager.getPOD(endPoint: endpoint) { (data: Data?) in
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


    //MARK: // -Table View Delegate
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allArticles.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! TopStoriesTableViewCell
        
        let article = allArticles[indexPath.row]
        cell.titleLabel.text = article.title
        cell.detailLabel.text = article.description
        
        APIRequestManager.manager.getPOD(endPoint: article.image ) {(data: Data?) in
            if let validData = data {
                    DispatchQueue.main.async {
                    cell.photoImageView.image = UIImage(data: validData)
                    cell.setNeedsDisplay()                }
            }
        
        }
      
        return cell
    }
<<<<<<< HEAD
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selected = segue.destination as? TopStoriesWebViewController,
            let cell = sender as? TopStoriesTableViewCell,
            let articleOf = localNewsTableView.indexPath(for: cell) {
            selected.article = allArticles[articleOf.row]
        }

    }
    

    
    
=======
>>>>>>> 566229f66abaaac5290d6dc44338e0b1ef8be40f
}

