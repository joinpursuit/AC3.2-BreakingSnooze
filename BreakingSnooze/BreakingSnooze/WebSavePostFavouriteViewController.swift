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
import CoreData

class WebSavePostFavouriteViewController: UIViewController, View2ViewTransitionPresented, UICollectionViewDataSource, UICollectionViewDelegate, WKUIDelegate, NSFetchedResultsControllerDelegate {
    
    weak var transitionController: TransitionController!
    var articles: [SourceArticles]?
    var image: UIImage!
    var currentArticle: SourceArticles!
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    private var controller: NSFetchedResultsController<NewsSource>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpViewHierarchyAndConstraints()
    }
    
    //MARK: Set up View Hierarchy and Constraints
    
    func setUpViewHierarchyAndConstraints () {
        let webConfiguration = WKWebViewConfiguration()
        //let userContentController = WKUserContentController()
        _ = [backButton,
             saveButton,
             shareButton,
             favouriteButton,
             webViewContainterView].map { self.view.addSubview($0) }
        
        _ = [backButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
             backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0),
             backButton.widthAnchor.constraint(equalToConstant: 30),
             
             shareButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 15.0),
             shareButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
             
             favouriteButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0),
             favouriteButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
             favouriteButton.widthAnchor.constraint(equalToConstant: 30),
             
             saveButton.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -15.0),
             saveButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
             
             
             webViewContainterView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
             webViewContainterView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
             webViewContainterView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
             webViewContainterView.bottomAnchor.constraint(equalTo: backButton.topAnchor)
            ].map { $0.isActive = true }

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        
        self.webViewContainterView.addSubview(webView)
        
        _ = [
            webView.topAnchor.constraint(equalTo: webViewContainterView.topAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewContainterView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewContainterView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: webViewContainterView.leadingAnchor)
            ].map { $0.isActive = true }
    }
    
    //MARK: - Webview FUN!
    
    
    
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
    
    var webView: WKWebView!
    
    lazy var webViewContainterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("👈", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        //button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return button
    }()
    
    lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("🖤", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        //button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightHeavy)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightHeavy)
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
        currentArticle = articles?[indexPath.row]
        cell.content.image = self.image
        cell.content.alpha = 0.35
        
        let request = URLRequest(url: URL(string: currentArticle.articleURL)!)
        webView.load(request)
        
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
    
    //MARK: - Actions 
    
    func backButtonPressed (sender: UIButton) {
        webView.goBack()
    }
    
    func favouritesButtonPresses (sender: UIButton) {
        
    }
}
