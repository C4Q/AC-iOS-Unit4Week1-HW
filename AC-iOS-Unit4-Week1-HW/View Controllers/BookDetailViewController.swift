//
//  BookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookSubtitleLabel: UILabel!
    @IBOutlet weak var bookLongDescriptionTextView: UITextView!
    @IBOutlet weak var addToFavoritesButton: UIButton!    
    
    /// segue from collection view cell to this detail view controller
    
    var detailedBook: BestSellerBook?
    var myGoogleBook: BookWrapper?
    var bookImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    
    }
    
    func loadDetails() {
        bookImageView.image = bookImage
        bookTitleLabel.text = detailedBook?.bookDetails[0].title
        if let myGoogleBook = myGoogleBook {
            bookSubtitleLabel.text = myGoogleBook.volumeInfo.subtitle ?? ""
            bookLongDescriptionTextView.text = myGoogleBook.volumeInfo.description ?? ""
        }
    }
    
    /// Add functionality for saving to favorites
    @IBAction func addToFavoritesButtonPressed(_ sender: UIButton) {
//        guard let image = bookImage else {return}
        

        
        
        
        let _ = FavoriteBookStore.manager.addToFavorites(book: detailedBook!)
//        navigationController?.popViewController(animated: true) // pops back to the previous View Controller

        // UIAlertController Initializer Statement
        let alertController = UIAlertController(title: "Added to Favorites", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        // First button definition
        let okAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
//        }
    }
}
