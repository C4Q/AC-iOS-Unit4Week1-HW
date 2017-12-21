//
//  BookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var book: BestSellerResults!
    var favoriteItemToBeEdited: Favorites!
    var googleBook: Items!
    var image: UIImage!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bookImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setImage()
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Favorite", message: "Added book to favorites", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setupUI() {
        titleLabel.text = book.book_details.first?.title
        textView.text = googleBook.volumeInfo.description
    }
    
    func setImage() {
        bookImage.image = self.image
    }
    
    @IBAction func addtoFavButtonPressed(_ sender: UIButton) {
        let newFavoriteBook = Favorites.init(title: (book.book_details.first?.title)!, description: googleBook.volumeInfo.description, imageUrl: (googleBook.volumeInfo.imageLinks?.thumbnail ?? ""))
        if let _ = favoriteItemToBeEdited {
            DataModel.shared.updateFavoritesItem(withUpdatedItem: newFavoriteBook)
        } else {
            DataModel.shared.addFavoritesItemToList(favoriteItem: newFavoriteBook)
            
        }
    }
}



