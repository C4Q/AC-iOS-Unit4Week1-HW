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
    @IBOutlet weak var bookTextView: UITextView!
    
    
    var book = DataPersistenceHelper.FavoritedBook.init(bookImagePath: " ", title: " ", isbn: " ", timeSaved: Date()) {
        didSet {
            print(book)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateSavedLabel.text = book.timeSaved.description
        self.titleLabel.text = book.title
        
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let cleanedPath = book.title.replacingOccurrences(of: " ", with: "%20") + book.isbn.description
        let imagePath = docDir!.appendingPathComponent(cleanedPath).path
        self.bookImageView.image = UIImage(contentsOfFile: imagePath) ?? #imageLiteral(resourceName: "no-image")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
