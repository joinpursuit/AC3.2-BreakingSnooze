//
//  TopStoriesWebViewController.swift
//  BreakingSnooze
//
//  Created by Kadell on 1/11/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import WebKit

class TopStoriesWebViewController: UIViewController, WKUIDelegate {

    var article: SourceArticles!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        setupWebView()
        

        let myURL = URL(string: article.articleURL)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }

//    func initializeFetchedResultsController() {
//        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Favorite.title), ascending: false)]
//        controller = NSFetchedResultsController(fetchRequest: request,
//                                                managedObjectContext: mainContext,
//                                                sectionNameKeyPath: nil,
//                                                cacheName: nil)
//        controller.delegate = self
//        
//        do {
//            try controller.performFetch()
//            // self.tableView.reloadData()
//        } catch {
//            fatalError("Failed to initialize FetchedResultsController: \(error)")
//        }
//    }
//    
//    func isThisInCoreData(article: SourceArticles) -> Favorite? {
//        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
//        let predicate: NSPredicate = NSPredicate(format: "title = %@", article.title)
//        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Favorite.title), ascending: false)]
//        request.predicate = predicate
//        let isItInThereController = NSFetchedResultsController(fetchRequest: request,
//                                                               managedObjectContext: mainContext,
//                                                               sectionNameKeyPath: nil,
//                                                               cacheName: nil)
//        do {
//            try isItInThereController.performFetch()
//        } catch {
//            print(error)
//        }
//        
//        guard let resultsArr = isItInThereController.fetchedObjects,
//            resultsArr.count > 0,
//            let result = resultsArr.first else { return nil }
//        
//        return result
//    }

    
    private func setupWebView() {
        self.edgesForExtendedLayout = []
        let webConfiguration = WKWebViewConfiguration()

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        
        if let containerView = view.viewWithTag(1) {
            containerView.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        }

    }
}
