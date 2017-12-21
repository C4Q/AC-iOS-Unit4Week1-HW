//
//  BookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit


class BookDetailViewController: UIViewController {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookSubtitleLabel: UILabel!
    @IBOutlet weak var bookSummaryTextView: UITextView!
    @IBOutlet weak var heartButton: UIBarButtonItem!
    
    
    var bookImage: UIImage?
    var nyTimesBook: BestSellerBook?
    var googleBook: GoogleBook?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookImageView.image = bookImage ?? #imageLiteral(resourceName: "no-image")
        bookTitleLabel.text = nyTimesBook?.bookDetails[0].title ?? "Title Unknown"
        bookSubtitleLabel.text = googleBook?.volumeInfo.authors?.joined(separator: ", ") ?? "Info Unknown"
        bookSummaryTextView.text = googleBook?.volumeInfo.description ?? "Summary Unknown"
        bookSummaryTextView.setContentOffset(CGPoint.zero, animated: true)
        
    }
    
    // Check to see if book is already favorited on viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if DataPersistenceHelper.manager.alreadyFavorited(isbn: nyTimesBook!.bookDetails[0].isbn13) {
            heartButton.tintColor = .red
        }

    }

    // Calls saveFavoriteBook function when heart button tapped
    @IBAction func heartButtonTapped(_ sender: UIBarButtonItem) {
        saveFavoriteBook()
    }
    
}

extension BookDetailViewController {
    
    func saveFavoriteBook() {
        // See if the variables are loaded correctly
        guard let bookImage = bookImage, let nyTimesBook = nyTimesBook, let googleBook = googleBook else { alertController(title: "Error", message: "Bad book data."); return }
        
        // Check if the book is already favorited and alert / return
        if DataPersistenceHelper.manager.alreadyFavorited(isbn: nyTimesBook.bookDetails[0].isbn13) {
            alertController(title: "Error", message: "Already favorited."); return
        }
        
        // Add favorite and alert with success and turn heart red
        DataPersistenceHelper.manager.addFavorite(nytBook: nyTimesBook, googleBook: googleBook, image: bookImage)
        heartButton.tintColor = .red
        alertController(title: "Success", message: "Saved to favorites.")
        
    }
    
    // Alter control function
    func alertController(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
