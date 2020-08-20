//
//  LoadingIndicatorControl.swift
//  Vkontakte
//
//  Created by Серёжа on 08/10/2019.
//  Copyright © 2019 appleS. All rights reserved.
//

import UIKit

class LoadingIndicatorControl: UIControl {
    
    @IBOutlet weak var loadingIndicatorOne: UIView!
    @IBOutlet weak var loadingIndicatorTwo: UIView!
    @IBOutlet weak var loadingIndicatorThree: UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loadingIndicatorOne.layer.cornerRadius = loadingIndicatorOne.frame.size.width / 2
        loadingIndicatorOne.clipsToBounds = true
        loadingIndicatorTwo.layer.cornerRadius = loadingIndicatorTwo.frame.size.width / 2
        loadingIndicatorTwo.clipsToBounds = true
        loadingIndicatorThree.layer.cornerRadius = loadingIndicatorThree.frame.size.width / 2
        loadingIndicatorThree.clipsToBounds = true
    }
}

