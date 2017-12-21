//
//  FavoriteDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteDetailViewController: UIViewController {
    
    @IBOutlet weak var favoriteDetailSubtitle: UILabel!
    @IBOutlet weak var favoriteDetailDescription: UITextView!
    @IBOutlet weak var favoriteDetailImage: UIImageView!
    
    var book: BooksInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteDetailSubtitle.text = book.volumeInfo.subtitle
        favoriteDetailDescription.text = book.volumeInfo.description
        
    }
    func loadImage() {
        guard let imageURLStr = book.volumeInfo.imageLinks?.thumbnail else {
            return
        }
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            self.favoriteDetailImage.image = onlineImage
            self.favoriteDetailImage.setNeedsLayout()
        }
        ImageAPIClient.manager.getImage(from: imageURLStr, completionHandler: completion, errorHandler: {print($0)})
    }


}
