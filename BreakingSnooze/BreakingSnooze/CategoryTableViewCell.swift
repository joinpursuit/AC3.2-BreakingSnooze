//
//  CategoryTableViewCell.swift
//  BreakingSnooze
//
//  Created by Cris on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

<<<<<<< HEAD
class CategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    var category: String! {
        
        didSet {
            initializeFetchedResultsController()
        }
        
    }
    
fileprivate let collectionViewReusableID = "SourceCollectionViewIdentifier"

class CategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
=======
>>>>>>> parent of 3a9fe61... CollectionView in Tableview cell working but still crasing
    @IBOutlet weak var sourceCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sourceCollectionView.delegate = self
        sourceCollectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        <#code#>
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
<<<<<<< HEAD
        guard let sections = controller.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
        return 0
=======
        <#code#>
>>>>>>> parent of 3a9fe61... CollectionView in Tableview cell working but still crasing
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
