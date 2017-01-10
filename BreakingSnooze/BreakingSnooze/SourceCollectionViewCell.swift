//
//  SourceCollectionViewCell.swift
//  BreakingSnooze
//
//  Created by Cris on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class SourceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sourceImageView: UIImageView!
    
    @IBOutlet weak var sourceNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceImageView.image = nil
    }
}
