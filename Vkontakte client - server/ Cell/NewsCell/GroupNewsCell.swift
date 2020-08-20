//
//  GroupNewsCell.swift
//  Vkontakte
//
//  Created by Серёжа on 08/09/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit

class GroupNewsCell: UITableViewCell {
    
    static let reuseIdentifier = "GroupNewsCell"
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
