//
//  ButtonsCell.swift
//  Vkontakte
//
//  Created by Серёжа on 14/09/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit

class ButtonsCell: UITableViewCell {
    
    static let reuseIdentifier = "ButtonsCell"
    
    @IBOutlet weak var likeView: VkButtons!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
