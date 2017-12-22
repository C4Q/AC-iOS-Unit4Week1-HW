//
//  FavoritesDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoritesDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bookCoverImage: UIImageView!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var bookDescription: UITextView!
    
    var favorite: Favorite!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setFavorites(favorite: favorite)
        
        
    }
    
    
    func setFavorites(favorite: Favorite){
        titleLabel.text = favorite.title
        if favorite.subtitle != nil{
            subtitleLabel.isHidden = false
            subtitleLabel.text = favorite.subtitle
        }
        bookDescription.text = favorite.description
            bookCoverImage.image = favorite.image
        
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-filled-32"), style: .plain, target: self, action: #selector(removeFavorite))
     
    }
    
    
    
    
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func favoritesButtonPressed(_ sender: UIBarButtonItem) {
        
        print("error")
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
