//
//  BestSellerCollectionViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerCell: UICollectionViewCell {
    
    //MARK - Outlets
    @IBOutlet weak var bookTextView: UITextView!
    @IBOutlet weak var bookWeeksLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK - Variables
    var bookExpandedDetails: Volume?
    var bookImage: UIImage?
    
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
