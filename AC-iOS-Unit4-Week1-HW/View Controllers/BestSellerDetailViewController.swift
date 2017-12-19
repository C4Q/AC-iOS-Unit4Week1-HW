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
    //var googleBook: GoogleBook?
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookSubtitle: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookLongDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let bestSeller = bestSeller else { return }
        GoogleBookAPIClient.manager.getGoogleBook(with: bestSeller.book_details[0].primary_isbn13, completionHandler: {
            let googleBook = $0
            self.bookTitleLabel.text = googleBook.volumeInfo.title
            if let subtitle = googleBook.volumeInfo.subtitle { self.bookSubtitle.text = subtitle }
            else { self.bookSubtitle.text = "" }
            self.bookLongDescription.text = googleBook.volumeInfo.description
            ImageFetchHelper.manager.getImage(from: googleBook.volumeInfo.imageLinks.thumbnail, completionHandler: { self.bookImage.image = $0 }, errorHandler: { print($0) })
            }, errorHandler: { print($0) })
    }

}

