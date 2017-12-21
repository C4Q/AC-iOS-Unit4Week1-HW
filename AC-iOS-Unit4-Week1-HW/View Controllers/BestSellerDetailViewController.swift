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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = book.volumeInfo.title
        bookDescription.text = book.volumeInfo.description
        setImage()
        

    }

    
    func setImage(){
        if book.volumeInfo.imageLinks == nil{
            bookCoverImage.image = #imageLiteral(resourceName: "image_not_available")
        }else{
            
            let imageUrl = book.volumeInfo.imageLinks?.thumbnail
                
                let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
                    self.bookCoverImage.image = onlineImage
                    self.bookCoverImage.setNeedsLayout()
            }
            ImageAPIClient.manager.getImage(from: imageUrl!, completionHandler: completion, errorHandler: {print ($0)})
            
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func addToFavoritePressed(_ sender: UIButton) {
   
    }
    

}
