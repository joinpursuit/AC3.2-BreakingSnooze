//
//  FavouritesViewController.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import View2ViewTransition
import CoreData

class FavouritesViewController: UIViewController, View2ViewTransitionPresenting, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var transitionController: TransitionController = TransitionController()
    var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var articles: [SourceArticles]?
    
    lazy var collectionView: UICollectionView = {
        
        let length: CGFloat = (UIScreen.main.bounds.size.width - 4.0)/3.0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: length, height: length)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .vertical
        
        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(PresentingCollectionViewCell.self, forCellWithReuseIdentifier: "presenting_cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        getDataFromAPI(source: "techcrunch")
    }
    
    //MARK: Get Data from API:
    func getDataFromAPI(source: String) {
        APIManager.shared.getData(urlString:  "https://newsapi.org/v1/articles?source=\(source)&apiKey=817c2d1fcd584b7ca26af5888e55bfd2&sortBy=latest") { (data: Data?) in
            guard let validData = data else { return }
            
            do {
                guard let validJSON = try JSONSerialization.jsonObject(with: validData, options: []) as? [String: Any] else { return }
                guard let articlesDictArr = validJSON["articles"] as? [[String: Any]] else { return }
                var articles = [SourceArticles]()
                
                for article in articlesDictArr {
                    guard let validObject = SourceArticles.init(from: article) else { continue }
                    articles.append(validObject)
                }
                self.articles = articles
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK: Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        
        let presentedViewController: WebSavePostFavouriteViewController = WebSavePostFavouriteViewController()
        
        presentedViewController.transitionController = self.transitionController
        transitionController.userInfo = ["destinationIndexPath": indexPath as NSIndexPath, "initialIndexPath": indexPath as NSIndexPath]
        
        // This example will push view controller if presenting view controller has navigation controller.
        // Otherwise, present another view controller
        if let navigationController = self.navigationController {
            
            // Set transitionController as a navigation controller delegate and push.
            navigationController.delegate = transitionController
            transitionController.push(viewController: presentedViewController, on: self, attached: presentedViewController)
            
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    // MARK: CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PresentingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "presenting_cell", for: indexPath) as! PresentingCollectionViewCell
        cell.contentView.backgroundColor = .white
        
        if let arr = articles {
            let currentArticle = arr[indexPath.row]
            cell.titleLabel.text = currentArticle.title
            cell.authorLabel.text = currentArticle.author
            cell.descriptionLabel.text = currentArticle.description
            APIManager.shared.getData(urlString: currentArticle.imageURL){ (data: Data?) in
                guard let validData = data else { return }
                DispatchQueue.main.async {
                    cell.contentImage.image = UIImage(data: validData)
                    cell.setNeedsLayout()
                }
            }
        }
        
        
        //cell.contentImage.image =
        
        return cell
    }
    
    
    
    //MARK: - Transition Delegates
    
    func initialFrame(_ userInfo: [String: AnyObject]?, isPresenting: Bool) -> CGRect {
        
        guard let indexPath: IndexPath = userInfo?["initialIndexPath"] as? IndexPath, let attributes: UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItem(at: indexPath) else {
            return CGRect.zero
        }
        return self.collectionView.convert(attributes.frame, to: self.collectionView.superview)
    }
    
    func initialView(_ userInfo: [String: AnyObject]?, isPresenting: Bool) -> UIView {
        
        let indexPath: IndexPath = userInfo!["initialIndexPath"] as! IndexPath
        let cell: UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
        
        return cell.contentView
    }
    
    func prepareInitialView(_ userInfo: [String : AnyObject]?, isPresenting: Bool) {
        let indexPath: IndexPath = userInfo!["initialIndexPath"] as! IndexPath
        
        if !isPresenting && !self.collectionView.indexPathsForVisibleItems.contains(indexPath) {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            self.collectionView.layoutIfNeeded()
        }
    }
}


