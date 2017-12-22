//
//  BestSellerCollectionViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bestSellerTimeLabel: UILabel!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    
    func configureCell(withBestSeller bestSeller: BestSeller) {
        self.bestSellerTimeLabel.text = "\(bestSeller.weeksOnList) week(s) on the best seller list"
        self.bookDescriptionLabel.text = bestSeller.bookDetails[0].description
    }
    
    func configureImageForCell(withGoogleBook googleBook: GoogleBook, errorHandler: @escaping (Error) -> Void) {
        self.bookImageView.image = nil
        self.bookImageView.image = #imageLiteral(resourceName: "placeholder-image")
        
        let imageLink = googleBook.volumeInfo.imageLinks.thumbnail
        
        if let image = ImageCache.manager.getImageFromCache(withURL: imageLink) {
            self.bookImageView.image = image
            self.setNeedsLayout()
        } else {
            ImageCache.manager.processImageInBackground(
                withURL: imageLink,
                completionHandler: { (onlineImage) in
                    self.bookImageView.image = onlineImage
                    self.setNeedsLayout()
            },
                errorHandler: errorHandler)
        }
    }
    
}
