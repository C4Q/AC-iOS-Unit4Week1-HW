//
//  FavoritesCollectionViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    func configureImageForCell(withGoogleBook googleBook: GoogleBook, errorHandler: @escaping (Error) -> Void) {
        
        guard let imageLink = googleBook.volumeInfo.imageLinks?.thumbnail else {
            self.favoriteImageView.image = #imageLiteral(resourceName: "placeholder-image")
            return
        }
        
        if let image = ImageCache.manager.getImageFromCache(withURL: imageLink) {
            self.favoriteImageView.image = image
            self.setNeedsLayout()
        } else {
            ImageCache.manager.processImageInBackground(
                withURL: imageLink,
                completionHandler: { (onlineImage) in
                    self.favoriteImageView.image = onlineImage
                    self.setNeedsLayout()
            },
                errorHandler: errorHandler)
        }
    }
    
}
