//
//  ImageNewsCell.swift
//  Vkontakte
//
//  Created by Серёжа on 08/09/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit

class ImageNewsCell: UITableViewCell {
    
    static let reuseIdentifier = "ImageNewsCell"
    
    @IBOutlet weak var imageNews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
