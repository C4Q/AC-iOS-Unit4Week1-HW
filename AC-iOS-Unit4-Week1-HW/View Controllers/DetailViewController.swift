//
//  DetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coverLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var longDescriptionTextView: UITextView!
    
    var book: Book! {
        didSet {
            let urlStr = "https://www.googleapis.com/books/v1/volumes?q=+isbn:"
            if let myISBNS = book.bookDetails {
                var isbn = myISBNS.first!.primaryISBN13
                let getBookDetail: ([Book]) -> Void = {(onlineImageBook) in
                    if !onlineImageBook.isEmpty {
                        self.bookDetail = onlineImageBook
                    } else {
                        isbn = myISBNS.first!.primaryISBN10
                        BooksAPIClient.manager.getBooks(from: urlStr + isbn, completionHandler: {self.bookDetail = $0}, errorHandler: {print($0)})
                    }
                }
                BooksAPIClient.manager.getBooks(from: urlStr + isbn, completionHandler: getBookDetail, errorHandler: {print($0)})
            }
        }
    }
    
    var bookDetail = [Book]() {
        didSet {
            loadLabels()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadLabels() {
        coverLabel.text = bookDetail.first?.volumeInfo?.title
        subTitleLabel.text = bookDetail.first?.volumeInfo?.subtitle ?? "No info found"
        longDescriptionTextView.text = bookDetail.first?.volumeInfo?.description ?? "No info found"
        BooksAPIClient.manager.getImage(from: (bookDetail.first?.volumeInfo?.imageLinks?.thumbnail)!, completionHandler: {self.imageView.image = $0}, errorHandler: {print($0)})
    }
    
    @IBAction func addFavorite(_ sender: UIButton) {
        
    }
    
}
