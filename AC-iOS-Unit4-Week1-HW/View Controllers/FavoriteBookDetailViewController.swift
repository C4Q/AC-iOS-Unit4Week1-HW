//
//  FavoriteBookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteBookDetailViewController: UIViewController {

    @IBOutlet weak var dateSavedLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var bookTextView: UITextView! {
        didSet {
            self.bookTextView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    // Placeholder var for favorite book
    var book = DataPersistenceHelper.FavoritedBook.init(bookImagePath: "", title: "", isbn: "", timeSaved: Date(), summary: "")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the ui elements
        self.dateSavedLabel.text = "Saved on: " + book.timeSaved.description.components(separatedBy: " ")[0...1].joined(separator: " at ")
        self.titleLabel.text = book.title
        self.detailLabel.text = "ISBN: " + book.isbn
        self.bookTextView.text = book.summary.html2String
        self.bookTextView.setContentOffset(CGPoint.zero, animated: false)
        
        // Get image from doc dir and set it
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let cleanedPath = book.title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)! + book.isbn.description
        let imagePath = docDir!.appendingPathComponent(cleanedPath).path
        self.bookImageView.image = UIImage(contentsOfFile: imagePath) ?? #imageLiteral(resourceName: "no-image")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
