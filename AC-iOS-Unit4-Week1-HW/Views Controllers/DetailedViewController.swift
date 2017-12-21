//
//  DetailedViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var longDescriptionTextView: UITextView!
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    var aBooksInfo = [BookWrapper]() {
        didSet {
            //Here is were the labels/view for the Detailed View Controller is reloaded with updated information.
            //The GoogleAPICall will update the subtitle label and bookImageView
            titleLabel.text = aBooksInfo[0].title
            subtitleLabel.text = aBooksInfo[0].subtitle ?? ""
            //API IMAGE CALL GOES HERE
            
        }
    }
    
    var aBook: BestSellers? {
        didSet {
            //Call IMAGE API HERE
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        guard let aBook = aBook else {return}
        bookImageView.image = #imageLiteral(resourceName: "NoDataAvailable") //To stop flickering
        titleLabel.text = aBook.bookDetails[0].title
        subtitleLabel.text = "" //Later update with subtitle from GoogleAPICall
        longDescriptionTextView.text = aBook.bookDetails[0].description
        
        //GoogleAPIClient call will happen here. String interpolated with the ISBN
        let callThisISBN = aBook.bookDetails[0].primaryISBN
        print(aBook.bookDetails[0].primaryISBN)
        let completion: ([BookWrapper]) -> Void = {(onlineBookInfo: [BookWrapper]) in
            self.aBooksInfo = onlineBookInfo
            
            print("Called for details for \(self.aBook?.listName ?? "BLANK") from Google API")
            
            let setImageToOnlineImage: (UIImage) -> Void = {(onlineImage: UIImage) in
                self.bookImageView.image = onlineImage
                self.bookImageView.setNeedsLayout()
            }
            
            ImageAPIClient.manager.getImage(from: self.aBooksInfo[0].imageLinks.thumbnail, completionHandler: setImageToOnlineImage, errorHandler: {print($0)})
            
        }
        GoogleAPIClient.manager.getBookInfo(matching: callThisISBN, completionHandler: completion, errorHandler: {print($0)})
        
    }
}
