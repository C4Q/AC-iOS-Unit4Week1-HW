//
//  FavoriteBookCellCollectionViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteBookCell: UICollectionViewCell {
    
    //MARK - outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK - Function
    func hideActivityIndicator(_ bool: Bool) {
        switch bool {
        case false:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        case true:
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
}
