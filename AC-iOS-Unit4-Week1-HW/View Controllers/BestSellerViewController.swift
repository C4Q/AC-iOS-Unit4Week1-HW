//
//  BestSellerViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerViewController: UIViewController {


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    // MARK: - variables
    var categories = [BookCategory]() {
        didSet {
            // reloads pickerView when variable categories is set
            categoryPicker.reloadAllComponents()
        }
    }
    
    var bestSellerBooks = [Book]() {
        didSet {
            print(bestSellerBooks)
        }
    }
    
    var bookDetails = [VolumeInfo]() {
        didSet {
            print(bookDetails)
        }
    }
    
    // MARK: - viewDidLoad overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        loadCategories()
    }
    
    // MARK: - functions
    func loadCategories() {
        NYTimesAPIClient.manager.getBestSellerCategories(completion: { self.categories = $0 }, errorHandler: { print($0) })
    }
    
//    func loadBestSellerBooks() {
//        NYTimesAPIClient.manager.getBestSellerBooks(for: categoryPicker.description., completion: {self.bestSellerBooks = $0}, errorHandler: {print($0)})
//    }
    
    //https://www.googleapis.com/books/v1/volumes?q=+isbn:0385514239
    

}

// MARK: - PickerView
extension BestSellerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // numberOfRowsInComponent
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count // number of dict in Array
    }
    
    // titleForRow
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].displayName
    }
    
    // didSelectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NYTimesAPIClient.manager.getBestSellerBooks(for: categories[row].listNameEncoded, completion: {self.bestSellerBooks = $0}, errorHandler: { print($0) })
    }
    
}

// MARK: CollectionView
extension BestSellerViewController: UICollectionViewDataSource {
    
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestSellerBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // casting to cell for reuse
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellerCell", for: indexPath) as! BestSellerCell
        let book = bestSellerBooks[indexPath.row]
        cell.bookWeeksLabel.text = book.weeks_on_list?.description
        cell.bookTextView.text = book.book_details[indexPath.row].description
        // set to nil to avoid image flicker
        cell.bookImageView.image = nil
        let isbn = book.isbns[0].isbn10
        GoogleAPIClient.manager.getBookDetails(for: isbn.description, completion: { self.bookDetails = [$0] }, errorHandler: {print($0)})
        
        // optional binding
        let imageUrl = bookDetails[indexPath.row].imageLinks.smallThumbnail
            
            //calling loadImage and loading image & refreshing layout in closure
            ImageAPIClient.manager.loadImage(from: imageUrl,
                                             completionHandler: {
                                                cell.bookImageView.image = $0
                                                cell.setNeedsLayout()},
                                             errorHandler: {print($0)})
        return cell
        }
    
    }



// MARK: CollectionView
extension BestSellerViewController: UICollectionViewDelegateFlowLayout {
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }
    
    // didSelectItemAt
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let bookSelected = bestSellerBooks[indexPath.row]
//
//        let alertVC = UIAlertController(title: "Added", message: "Added to favorites", preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        present(alertVC, animated: true, completion: nil)
//    }
}
