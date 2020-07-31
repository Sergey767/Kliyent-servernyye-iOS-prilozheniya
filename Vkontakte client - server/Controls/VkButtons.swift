//
//  VkButtons.swift
//  Vkontakte
//
//  Created by Серёжа on 19/09/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit

class VkButtons: UIControl {
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            let unlikedImage = UIImage(named: "unliked")
            self.likeButton.setImage(unlikedImage, for: .normal)
            let likeImage = UIImage(named: "like")
            self.likeButton.setImage(likeImage, for: .selected)
        }
    }
    
    @IBOutlet weak var commentsButton: UIButton! {
        didSet {
            let commentsImage = UIImage(named: "comments")
            self.commentsButton.setImage(commentsImage, for: .normal)
        }
    }
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            let shareImage = UIImage(named: "share")
            self.shareButton.setImage(shareImage, for: .normal)
        }
    }
    
    @IBOutlet weak var viewsButton: UIButton! {
        didSet {
            let viewsImage = UIImage(named: "views")
            self.viewsButton.setImage(viewsImage, for: .normal)
        }
    }
    
    @IBOutlet weak var viewsLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews () {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(VkButtons.handleTap(_:)))
        
        self.likeButton.addGestureRecognizer(tapGR)
    }
    
    @objc func handleTap(_: UITapGestureRecognizer) {
        
        self.likeButton.isSelected = !self.likeButton.isSelected
        
        UILabel.transition(with: likeButton, duration: 0.3, options: .transitionFlipFromBottom, animations: {
            self.likeButton
        }, completion: nil)
    }
}
