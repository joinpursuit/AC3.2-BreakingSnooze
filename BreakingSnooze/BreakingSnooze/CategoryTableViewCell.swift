//
//  CategoryTableViewCell.swift
//  BreakingSnooze
//
//  Created by Cris on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import CoreData

fileprivate let collectionViewReusableID = "SourceCollectionViewIdentifier"
fileprivate let segueID = "sourceArticlesSegue"
protocol Pusher {
    func pushViewController(vc: FavouritesViewController, sourceID: String)
}


class CategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    var delegate: Pusher!
    var category: String! {
        didSet {
            initializeFetchedResultsController()
            sourceCollectionView.delegate = self
            sourceCollectionView.dataSource = self
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBOutlet weak var sourceCollectionView: UICollectionView!
    
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private var controller: NSFetchedResultsController<NewsSource>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initializeFetchedResultsController() {
        let request: NSFetchRequest<NewsSource> = NewsSource.fetchRequest()
        let sort = NSSortDescriptor(key: "sourceLogo", ascending: true)
        
        request.sortDescriptors =  [sort]
        
        let predicate = NSPredicate(format: "%K == %@", "category", self.category)
        request.predicate = predicate
        self.controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: "category", cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
             sourceCollectionView.reloadData()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        guard let sections = controller.sections else {
//            print("No sections in fetchedResultsController")
//            return 0
//        }
//        return sections.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = controller.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewReusableID, for: indexPath)
        let source = controller.object(at: indexPath)
        if let cell = cell as? SourceCollectionViewCell {
            APIManager.shared.getData(urlString: source.sourceLogo!, completion: { (data) in
                guard let validData = data else { return }
                guard let validImage = UIImage(data: validData) else { return }
                DispatchQueue.main.async {
                    cell.sourceImageView.image = validImage
                    cell.sourceNameLabel.text = source.sourceName
                }
            })
        }        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "favouriteViewController")
        
        delegate.pushViewController(vc: vc as! FavouritesViewController, sourceID: controller.object(at: indexPath).sourceID!)
    }
}
