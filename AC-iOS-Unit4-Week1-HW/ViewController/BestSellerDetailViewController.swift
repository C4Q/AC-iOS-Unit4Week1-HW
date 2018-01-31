//
//  BestSellerDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerDetailViewController: UIViewController {

    var book: BooksInfo?
    
    @IBOutlet weak var longDescription: UITextView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var detailViewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longDescription.text = book?.volumeInfo.description
        subtitle.text = book?.volumeInfo.subtitle
        loadImage()
        
    }

   

    @IBAction func addToFavorite(_ sender: UIButton) {
        guard let image = detailViewImage.image else { return }
        guard let unwrappedBook = book else {return}
        let _ = BookDataStore.manager.addToFavorites(book: unwrappedBook, andImage: image)
        navigationController?.popViewController(animated: true)
    }
    
    func loadImage() {
        guard let imageURLStr = book?.volumeInfo.imageLinks?.thumbnail else {
            return 
        }
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            self.detailViewImage.image = onlineImage
            self.detailViewImage.setNeedsLayout()
        }
        ImageAPIClient.manager.getImage(from: imageURLStr, completionHandler: completion, errorHandler: {print($0)})
    }
}
