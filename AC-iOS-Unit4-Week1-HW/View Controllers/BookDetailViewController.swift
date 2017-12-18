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
    
    
    /// segue from collection view cell to this detail view controller
    
    var nytBook: BestSellerBook!
    var googleBook: BookWrapper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let bookTitle = nytBook.bookDetails[0].title else { return }
        self.bookTitleLabel.text = bookTitle
        guard let bookSubtitle = googleBook.volumeInfo.subtitle else { return }
        self.bookSubtitleLabel.text = bookSubtitle
    }
    /// LOAD THE IMAGE OF THE BOOK
    //        self.bookImageView.image =
}


