//
//  BestSellerDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerDetailViewController: UIViewController {

    var bestSeller: BestSeller?
    var googleBook: GoogleBook?
    var coverImage: UIImage?
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookSubtitle: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookLongDescription: UITextView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let bestSeller = bestSeller else { return }
        if DataPersistenceModel.shared.isBookAlreadySaved(isbn: bestSeller.book_details[0].primary_isbn13) {
            favoriteButton.image = #imageLiteral(resourceName: "favorite_filled")
        }
        GoogleBookAPIClient.manager.getGoogleBook(with: bestSeller.book_details[0].primary_isbn13, completionHandler: {
            self.googleBook = $0
            guard let googleBook = self.googleBook else { return }
            self.bookTitleLabel.text = googleBook.volumeInfo.title
            if let subtitle = googleBook.volumeInfo.subtitle { self.bookSubtitle.text = subtitle }
            else { self.bookSubtitle.text = "" }
            self.bookLongDescription.text = googleBook.volumeInfo.description
        }, errorHandler: {_ in
            self.bookImage.image = self.coverImage
            self.bookTitleLabel.text = bestSeller.book_details[0].title
            self.bookLongDescription.text = bestSeller.book_details[0].description
            self.bookSubtitle.text = ""
        })
        guard let coverImage = coverImage else { return }
        bookImage.image = coverImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bookLongDescription.setContentOffset(CGPoint.zero, animated: false)
    }

    @IBAction func FavoriteButtonPressed(_ sender: UIBarButtonItem) {
        guard let bestSeller = bestSeller, let coverImage = coverImage else { return }
        favoriteButton.image = #imageLiteral(resourceName: "favorite_filled")
        if DataPersistenceModel.shared.isBookAlreadySaved(isbn: bestSeller.book_details[0].primary_isbn13) {
            showAlertController(with: "Message", message: "Book already favorited")
            return
        }
        if let googleBook = googleBook {
            DataPersistenceModel.shared.addFavoriteBookToList(book: googleBook, with: coverImage, and: bestSeller.book_details[0].primary_isbn13)
        } else {
            let bookDetails = bestSeller.book_details[0]
            let googleBookInfo = VolumeInfoWrapper(title: bookDetails.title, subtitle: nil, authors: [bookDetails.author], description: bookDetails.description!, imageLinks: nil)
            let googleBook = GoogleBook(volumeInfo: googleBookInfo)
            DataPersistenceModel.shared.addFavoriteBookToList(book: googleBook, with: coverImage, and: bestSeller.book_details[0].primary_isbn13)
        }
    }
    
    func showAlertController(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

