//
//  BestSellerDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bookCoverImage: UIImageView!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var bookDescription: UITextView!
    
    var book: BookInfo!
    var imageCover: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setImage(book: book)
        

    }

    
    func setImage(book: BookInfo){
        titleLabel.text = book.volumeInfo.title
        bookDescription.text = book.volumeInfo.description
        
        if book.volumeInfo.subtitle != nil{
            subtitleLabel.isHidden = false
            subtitleLabel.text = book.volumeInfo.subtitle
        }
        
        
        
        if book.volumeInfo.imageLinks == nil{
            bookCoverImage.image = #imageLiteral(resourceName: "image_not_available")
        }else{
            bookCoverImage.image = imageCover
        }
        
        
        if PersistentStoreManager.manager.isBookInFavorites(book: book) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-filled-32"), style: .plain, target: self, action: #selector(removeFavorite))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-unfilled-32"), style: .plain, target: self, action: #selector(favoritesButtonPressed(_:)))
        }
    }
    
    
    
    
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func favoritesButtonPressed(_ sender: UIBarButtonItem) {
        guard let image = bookCoverImage.image else{return}
        let _ = PersistentStoreManager.manager.addToFavorites(book: book, andImage: image)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func removeFavorite() {
        guard let favoriteToBeRemoved = PersistentStoreManager.manager.getFavoriteWithTitle(title: titleLabel.text!)
            else { return }
        let index = PersistentStoreManager.manager.getFavorites().index{$0.title == titleLabel.text!}
        if let index = index {
            let _ = PersistentStoreManager.manager.removeFavorite(fromIndex: index, andBookImage: favoriteToBeRemoved)
            dismiss(animated: true, completion: nil)
        }
    }

    

}
