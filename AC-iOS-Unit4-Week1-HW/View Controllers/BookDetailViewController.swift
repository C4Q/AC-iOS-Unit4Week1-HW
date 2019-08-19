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
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    
    var googleBook: GoogleBook?
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let savedGoogleBooks = GoogleBookData.manager.getGoogleBooks()
        
        guard let googleBook = googleBook else {
            return
        }
        
        if savedGoogleBooks.contains(googleBook) {
            favoritesButton.image = #imageLiteral(resourceName: "filled")
            favoritesButton.tintColor = UIColor(red: 1, green: 0.414, blue: 0.515, alpha: 1)
        } else {
            favoritesButton.image = #imageLiteral(resourceName: "unfilled")
            favoritesButton.tintColor = UIColor(red: 0.674, green: 0.686, blue: 0.741, alpha: 1)
        }
    }

    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        let savedGoogleBooks = GoogleBookData.manager.getGoogleBooks()
        
        guard let googleBook = googleBook else {
            
            let alertController = UIAlertController(title: "Error", message: "Google Book API did not have an entry for this isbn.", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        if savedGoogleBooks.contains(googleBook) {
            GoogleBookData.manager.removeGoogleBook(googleBook)
            sender.image = #imageLiteral(resourceName: "unfilled")
            sender.tintColor = UIColor(red: 0.674, green: 0.686, blue: 0.741, alpha: 1)
        } else {
            GoogleBookData.manager.addGoogleBook(googleBook)
            
            let alertController = UIAlertController(title: "Success", message: "Saved to Favorites", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            sender.image = #imageLiteral(resourceName: "filled")
            sender.tintColor = UIColor(red: 1, green: 0.414, blue: 0.515, alpha: 1)
        }
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
