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
    
    var bookImage: UIImage?
    var nyTimesBook: BestSellerBook?
    var googleBook: GoogleBook?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let bookImage = bookImage, let nyTimesBook = nyTimesBook, let googleBook = googleBook else { return }
        
        bookImageView.image = bookImage
        
        bookTitleLabel.text = nyTimesBook.bookDetails[0].title
        
        bookSubtitleLabel.text = googleBook.searchInfo.textSnippet
        
        bookSummaryTextView.text = googleBook.volumeInfo.description
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        saveFavoriteBook()
    }
    
    
    
    
}

extension BookDetailViewController {
    
    func saveFavoriteBook() {
        guard let bookImage = bookImage, let nyTimesBook = nyTimesBook, let googleBook = googleBook else { return }
        DataPersistenceHelper.manager.addFavorite(isbn: nyTimesBook.bookDetails[0].isbn13, bookTitle: nyTimesBook.bookDetails[0].title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!, image: bookImage)
        
        
    }
    
    
}
