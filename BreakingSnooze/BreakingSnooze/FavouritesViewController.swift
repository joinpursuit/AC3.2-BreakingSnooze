//
//  FavouritesViewController.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import View2ViewTransition

class FavouritesViewController: UIViewController, View2ViewTransitionPresenting, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var transitionController: TransitionController = TransitionController()
    
    lazy var collectionView: UICollectionView = {
        
        let lendth: CGFloat = (UIScreen.main.bounds.size.width - 4.0)/3.0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: lendth, height: lendth)
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
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTranisitinoDelegate () {
        let presentedViewController: WebSavePostFavouriteViewController = WebSavePostFavouriteViewController()
        presentedViewController.transitioningDelegate = self.transitionController
        
        self.transitionController.present(viewController: presentedViewController, on: self, attached: presentedViewController, completion: nil)
    }
    
    // MARK: CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PresentingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "presenting_cell", for: indexPath) as! PresentingCollectionViewCell
        cell.contentView.backgroundColor = UIColor.lightGray
        
        let number: Int = indexPath.item%4 + 1
        cell.content.image = UIImage(named: "image\(number)")
        
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


public class PresentingCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.content)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var content: UIImageView = {
        let view: UIImageView = UIImageView(frame: self.contentView.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.gray
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
}
