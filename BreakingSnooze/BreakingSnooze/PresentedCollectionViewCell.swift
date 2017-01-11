//
//  PresentedCollectionViewCell.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import View2ViewTransition

public class PresentedCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.content)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var content: UIImageView = {
        let margin: CGFloat = 2.0
        let width: CGFloat = (UIScreen.main.bounds.size.width - margin*2.0)
        let height: CGFloat = (UIScreen.main.bounds.size.height - 160.0)
        let frame: CGRect = CGRect(x: margin, y: (UIScreen.main.bounds.size.height - height)/2.0, width: width, height: height)
        let view: UIImageView = UIImageView(frame: frame)
        view.alpha = 0.35
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
}
