//
//  DetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var selectedBook: Book?
    var bookName = String()
    var bookSummary = String()
    var bookImage: UIImage?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLabel.text = bookName
        summaryTextField.text = bookSummary
        imageView.image = bookImage ?? #imageLiteral(resourceName: "noImage")
    }
    
    // MARK: - UI & Delegate
    
    @IBOutlet weak var summaryTextField: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton! {
        didSet {
            if navigationController?.viewControllers.first is FavoriteViewController {
                favoriteButton.isHidden = true
            }
        }
    }
    
    // MARK: - User Actions
    @IBAction func saveFavoritePressed(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Adding \(bookName) to favorites." , message: "Are you sure?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            if var book = self.selectedBook {
                book.isbnSummary = self.bookSummary
                if let image = self.bookImage {
                    let _ = FavoriteModel.manager.storeImageToDisk(image: image, book: book)
                }
                KeyedArchiverModel.shared.addFavBook(book: book)
                self.navigationController?.popViewController(animated: true)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
