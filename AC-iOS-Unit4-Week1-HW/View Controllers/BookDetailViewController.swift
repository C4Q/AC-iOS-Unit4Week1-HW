//
//  BookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var googleBook: GoogleBook?
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    func setUpViews() {
        titleLabel.text = googleBook?.volumeInfo.title ?? "No title available"
        subtitleLabel.text = googleBook?.volumeInfo.subtitle ?? ""
        authorLabel.text = googleBook?.volumeInfo.authors?.joined(separator: ", ") ?? "No author available"
        descriptionTextView.text = googleBook?.volumeInfo.description ?? "No description available."
        setUpImage()
    }
    
    func setUpImage() {
        bookImageView.image = image
    }
    
}
