//
//  BookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var bookSubtitleLabel: UILabel!
    
    // MARK: - variables
    var buttonActive = false
    var bookExpandedDetails: Volume?
    var bookImage: UIImage?
    
    // MARK: - viewDidLoad overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFavorites()
        setupUI()
    }
    
    // MARK: - functions
    // tried a switch statement, but kept failing. Resorted to stackoverflow:
    //https://stackoverflow.com/questions/45702295/how-to-change-uibuttons-image-every-time-it-is-pressed
    
    @IBAction func buttonPressed() {
        if buttonActive {
            favoriteButton.setImage(UIImage(named: "favoriteUnfilled"), for: .normal)
            let message = DataModel.manager.removeFavoriteBook(by: (bookExpandedDetails?.volumeInfo.industryIdentifiers[0].identifier)!)
            alertController(title: "Alert!", message: message)
        } else {
            favoriteButton.setImage(UIImage(named: "favoriteFilled"), for: .normal)
            let message = DataModel.manager.setFavorite(book: bookExpandedDetails, image: bookImageView.image!)
            alertController(title: "Alert!", message: message)
        }
        buttonActive = !buttonActive
    }
    
    func searchFavorites() {
        guard let isbn = bookExpandedDetails?.volumeInfo.industryIdentifiers[0].identifier else { return }
        favoriteButton.imageView?.image = DataModel.manager.checkForExistingFavorite(by: isbn) == true ? #imageLiteral(resourceName: "favoriteFilled") : #imageLiteral(resourceName: "favoriteUnfilled")
    }
    
    func setupUI() {
        bookImageView.image = bookImage
        bookNameLabel.text = bookExpandedDetails?.volumeInfo.title
        bookSubtitleLabel.text = bookExpandedDetails?.volumeInfo.subtitle ?? "Subtitle: Unavailable"
        bookTextView.text = bookExpandedDetails?.volumeInfo.description ?? "Detailed description unavailable."
    }
    
    func alertController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}

