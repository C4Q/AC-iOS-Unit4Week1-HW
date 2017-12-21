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
    
    
    //Back Button since a segue to a nav controller doesn't automatically add a back button that pops off the view
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteButton(_ sender: UIBarButtonItem) {
        //Add a button to save to favorites
        //Consider making it a switch so that the on position is for saving, and the off position means it's not saved.
        //Call append function to Favorites Keyed Archiver
    }
    
    var aBooksInfo = [BookInfo]() {
        didSet {
            //Here is were the labels/view for the Detailed View Controller is reloaded with updated information.
            titleLabel.text = aBooksInfo[0].title
            subtitleLabel.text = aBooksInfo[0].subtitle ?? ""
        }
    }
    
    var aBook: BestSellers? {
        didSet {
            guard let callThisISBN = aBook?.bookDetails[0].primaryISBN else {return}
            let completion: ([BookInfo]) -> Void = {(onlineBookInfo: [BookInfo]) in
                self.aBooksInfo = onlineBookInfo
                
                print("Called for details for \(self.aBook?.listName ?? "BLANK") from Google API")
                
            }
            GoogleAPIClient.manager.getBookInfo(matching: callThisISBN,
                                                completionHandler: completion,
                                                errorHandler: {print($0)})

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
        subtitleLabel.text = "Subtitle Goes Here" //Later update with subtitle from GoogleAPICall
        longDescriptionTextView.text = aBook.bookDetails[0].description
        
        //GoogleAPIClient call will happen here. String interpolated with the ISBN
        //The GoogleAPICall will update the subtitle label and bookImageView
        
        
        
        
        
        
    }

    

}
