//
//  ViewController.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/9/17.
//  Copyright © 2017 C4Q. All rights reserved.
//
//APIKEY = 817c2d1fcd584b7ca26af5888e55bfd2
//APIKEYFORRADIO = ed4616717617f6e9d090f88c8f
import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionsImageView: UIImageView!
    
    var sourcesURL = "https://newsapi.org/v1/sources"
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        getSources()
        locationManager.delegate = self
        permission()
        // Do any additional setup after loading the view, typically from a nib.
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
                    self.locationLabel.text = "\(self.currentWeather[0].name),  \(self.currentWeather[0].country)"
                }
                
            }
        }
        
    }
    
    func getSources() {
        APIManager.shared.getData(urlString: self.sourcesURL)
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
    
    func getArticlesFromSources() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
        dump(latCoord)
        dump(longCoord)
        
        
        loadData(endPoint: "http://api.openweathermap.org/data/2.5/weather?lat=\(latCoord)&lon=\(longCoord)&appid=22b1e9d953bb8df3bcdf747f549be645&units=imperial")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }

}

