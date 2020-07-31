//
//  SearchGroupCell.swift
//  Vkontakte
//
//  Created by Серёжа on 11/07/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit
import Kingfisher

class SearchGroupCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchGroupCell"
    
    @IBOutlet weak var searchGroupName: UILabel!
    @IBOutlet weak var searchGroupImageView: UIImageView!
    
    public func configure(with searchGroup: Group) {
        
        let name = searchGroup.name
        searchGroupName.text = name
        
        let url = URL(string: searchGroup.photo)
        searchGroupImageView.kf.setImage(with: url)
        searchGroupImageView.layer.cornerRadius = searchGroupImageView.frame.size.width / 2
        searchGroupImageView.clipsToBounds = true
    }
}
