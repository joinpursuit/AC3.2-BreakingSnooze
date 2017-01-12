//
//  TopStoriesTableViewCell.swift
//  BreakingSnooze
//
//  Created by Kadell on 1/11/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class TopStoriesTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
   
}
