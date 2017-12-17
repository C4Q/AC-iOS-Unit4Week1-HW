//
//  BestSellersViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellersViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var categories = [BestSellerCategory]() {
        didSet {
            
            pickerView.reloadAllComponents()
            
            // After categories are loaded check if there are defaults
            if let defaults = UserDefaultsHelper.manager.getValue() {
                pickerView.selectRow(defaults.pickerPosition, inComponent:0, animated:true)
                NYTimesAPIClient.manager.getBestSellerBooks(from: categories[defaults.pickerPosition].listNameEncoded, completionHandler: { self.books = $0 }, errorHandler: { print($0) })
            }
            
        }
    }
    
    var books = [BestSellerBook]() {
        didSet {
            collectionView.reloadData()
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self; pickerView.delegate = self
        collectionView.dataSource = self; collectionView.delegate = self

        loadCategories()
        
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

// MARK: - Helper Functions

extension BestSellersViewController {
    
    // Loads the initial best seller categories
    func loadCategories() {
        NYTimesAPIClient.manager.getBestSellerCategories(completionHandler: { self.categories = $0 }, errorHandler: { print($0) })
    }
    
}

// MARK: - Picker View

extension BestSellersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].displayName
    }
    
    // When a picker view row is selected a call is made to the NYT API and sets the books array to the books from the call
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NYTimesAPIClient.manager.getBestSellerBooks(from: categories[row].listNameEncoded, completionHandler: { self.books = $0 }, errorHandler: { print($0) })
    }
    
}

// MARK: - Collection View

extension BestSellersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellerCell", for: indexPath)
        // Get selected book
        let book = books[indexPath.row]
        
        // Make cell the custom cell
        if let cell = cell as? BestSellerCollectionViewCell {
            cell.bestSellerImageView.image = nil
            cell.bestSellerTimeLabel.text = "Weeks on List: " + book.weeksOnList.description
            cell.bestSellerTitleLabel.text = book.bookDetails[0].title
            loadImage(book: book, for: cell)
        }
        return cell
    }
    
    // Function to make calls to Google Books API and get an image from an url
    func loadImage(book: BestSellerBook, for cell: BestSellerCollectionViewCell) {
        
        let isbn = book.bookDetails[0].isbn13
        
        // In the completion handler the getImage function is called to set the cells image
        GoogleBooksAPIClient.manager.getBookData(isbn: isbn, completionHandler: {
            cell.bestSellerSummaryTextView.text = $0[0].searchInfo.textSnippet.html2String
            let imageUrl = $0[0].volumeInfo.imageLinks.thumbnail
            
            ImageAPIClient.manager.getImage(from: imageUrl, completionHandler: { cell.bestSellerImageView.image = $0; cell.setNeedsLayout() }, errorHandler: { print($0) })
            
            }, errorHandler: { print($0) })
    }
    
    // Makes the item size of the collection view equal to the collection view's bounds
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}
