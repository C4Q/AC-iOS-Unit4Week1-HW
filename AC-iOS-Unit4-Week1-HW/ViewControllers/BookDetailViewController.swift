//
//  BookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    var image: UIImage?
    var books: BookList?
    var googleBook: GoogleBooks?
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    }

    func loadDetails() {
        titleLabel.text = googleBook?.volumeInfo.title
        descriptionLabel.text = googleBook?.volumeInfo.description
        subtitleLabel.text = googleBook?.volumeInfo.subtitle
        authorLabel.text = googleBook?.volumeInfo.authors[0]
        imageView.image = image
        
        
    }

}
