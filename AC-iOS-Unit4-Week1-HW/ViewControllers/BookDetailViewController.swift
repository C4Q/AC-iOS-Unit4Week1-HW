//
//  BookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    var bookImage: UIImage?
    var selectedBook: BookList?
    var googleBook: GoogleBooks?
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        saveFavoriteBook()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    }

    func loadDetails() {
        titleLabel.text = googleBook?.volumeInfo.title ?? nil
        descriptionLabel.text = googleBook?.volumeInfo.description ?? nil
        subtitleLabel.text = googleBook?.volumeInfo.subtitle ?? nil
        authorLabel.text = googleBook?.volumeInfo.authors?.joined(separator: ", ") ?? nil
        imageView.image = bookImage ?? #imageLiteral(resourceName: "not-available")
    }
    
    func saveFavoriteBook() {
        guard let googleBook = googleBook, let selectedBook = selectedBook, let bookImage = bookImage else { alertController(title: "Error", message: "Bad book data."); return }
        
        if DataModel.shared.favoriteCheck(with: selectedBook.isbns[0].isbn10) {
            alertController(title: "Error", message: "Already favorited."); return
        }
        
        DataModel.shared.addFavorite(book: selectedBook, googleBook: googleBook, image: bookImage)
        alertController(title: "Added", message: "Saved to favorites.")
        
    }
    func alertController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }

}
