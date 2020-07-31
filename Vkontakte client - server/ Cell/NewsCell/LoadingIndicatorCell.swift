//
//  LoadingIndicatorCell.swift
//  Vkontakte
//
//  Created by Серёжа on 08/10/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit

class LoadingIndicatorCell: UITableViewCell {
    
    static let reuseIdentifier = "LoadingIndicatorCell"
    
    @IBOutlet weak var loadingIndicatorView: LoadingIndicatorControl!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
