//
//  WebSavePostFavouriteViewController.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import View2ViewTransition
import WebKit

class WebSavePostFavouriteViewController: UIViewController, View2ViewTransitionPresented, UICollectionViewDataSource, UICollectionViewDelegate, WKUIDelegate {
    
    weak var transitionController: TransitionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    //MARK: Set up View Hierarchy
    
    func setUpViewHierarchy () {
        let webConfiguration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()

        _ = []
    }
    
    //MARK View2ViewTransitionPresented Delegates
    
    func destinationFrame(_ userInfo: [String: AnyObject]?, isPresenting: Bool) -> CGRect {
        
        let indexPath: IndexPath = userInfo!["destinationIndexPath"] as! IndexPath
        let cell: PresentedCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! PresentedCollectionViewCell
        return cell.content.frame
    }
    
    func destinationView(_ userInfo: [String: AnyObject]?, isPresenting: Bool) -> UIView {
        
        let indexPath: IndexPath = userInfo!["destinationIndexPath"] as! IndexPath
        let cell: PresentedCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! PresentedCollectionViewCell
        return cell.content
    }
    
    func prepareDestinationView(_ userInfo: [String: AnyObject]?, isPresenting: Bool) {
        
        if isPresenting {
            
            let indexPath: IndexPath = userInfo!["destinationIndexPath"] as! IndexPath
            let contentOfffset: CGPoint = CGPoint(x: self.collectionView.frame.size.width * CGFloat(indexPath.item), y: 0.0)
            self.collectionView.contentOffset = contentOfffset
            
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }
    }
    
    //MARK: - Views
//    lazy var webView: WKWebView = {
//        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
//        return webView
//    }()

    
    lazy var webViewContainterView: UIView = {
        let view = UIView()
        return UIView()
    }()
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("👈", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightHeavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return button
    }()
    
    lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("🖤", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightHeavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightHeavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightHeavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = self.view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(PresentedCollectionViewCell.self, forCellWithReuseIdentifier: "presented_cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
   
    lazy var titleLabel: UILabel = {
        let font: UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        let label: UILabel = UILabel()
        label.font = font
        label.text = "Detail"
        label.sizeToFit()
        return label
    }()
    
    // MARK: CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PresentedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "presented_cell", for: indexPath) as! PresentedCollectionViewCell
        cell.contentView.backgroundColor = UIColor.white
        
        let number: Int = indexPath.item%4 + 1
        cell.content.image = UIImage(named: "image\(number)")
        
        return cell
    }
    
    // MARK: Gesture Delegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let indexPath: NSIndexPath = self.collectionView.indexPathsForVisibleItems.first! as NSIndexPath
        self.transitionController.userInfo = ["destinationIndexPath": indexPath, "initialIndexPath": indexPath]
        
        let panGestureRecognizer: UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let transate: CGPoint = panGestureRecognizer.translation(in: self.view)
        return Double(abs(transate.y)/abs(transate.x)) > M_PI_4
    }
}
