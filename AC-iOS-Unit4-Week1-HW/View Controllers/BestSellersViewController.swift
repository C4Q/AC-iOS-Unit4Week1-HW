//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellersViewController: UIViewController {
    
    @IBOutlet weak var bestSellersCollectionView: UICollectionView!
    
    @IBOutlet weak var bestSellersCategoryPickerView: UIPickerView!
    
    
    
    var categories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.bestSellersCategoryPickerView.reloadAllComponents()
            }
        }
    }
    
    var nytBooksWithISBN = [BestSellerBook]() {
        didSet {
            DispatchQueue.main.async {
                self.bestSellersCollectionView.reloadData()
            }
        }
    }
    
    var googleBooksWithImages = [BookWrapper]() {
        didSet {
            DispatchQueue.main.async {
                self.bestSellersCollectionView.reloadData()
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bestSellersCollectionView.dataSource = self
        self.bestSellersCategoryPickerView.dataSource = self
        self.bestSellersCategoryPickerView.delegate = self
        loadCategories()
    }
    
    func loadCategories() {
        CategoryAPIClient.shared.getCategories(completionHandler: {self.categories = $0}, errorHandler: {print($0)})
    }
    
/// load images from google
    
//    func load
    
    
}


/// Best Sellers Collection View
extension BestSellersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookCell = bestSellersCollectionView.dequeueReusableCell(withReuseIdentifier: "Book Cover Cell", for: indexPath) as! BestSellerCollectionViewCell
        let bookWithISBN = nytBooksWithISBN[indexPath.row]
//        let bookWithImage = googleBooksWithImages[indexPath.row]
        bookCell.shortDescriptionLabel.text = bookWithISBN.bookDetails.description
        bookCell.weeksOnListLabel.text = "\(bookWithISBN.weeksOnList) Weeks On Best Sellers List"
        bookCell.bestSellerImageView.image = nil
//        let imageUrlStr: String = bookWithImage.volumeInfo.imageLinks.thumbnail
//        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
//            bookCell.bestSellerImageView.image = onlineImage
//        }
//        ImageAPIClient.manager.loadImage(from: imageUrlStr, completionHandler: completion, errorHandler: {print($0)})
        return bookCell
    }
    
    
}




/// Picker
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
    
    
        /// loadCollectionView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = categories[row]
        
        let completion: ([BestSellerBook]) -> Void = {(onlineBestSellers: [BestSellerBook]) in
            self.nytBooksWithISBN = onlineBestSellers
        }
        
//        let errorHandler: (AppError) -> Void = {(error: AppError) in
//            switch error {
//                case
//            }
//        }
        
        
        BestSellerBookAPIClient.shared.getNYTBooks(category: category.listNameEncoded , completionHandler: completion, errorHandler: {print($0)})
    }
    
    
}

let spacingBetweenCells = UIScreen.main.bounds.size.width * 0.05

/// format the Best Seller collection view

extension BestSellersViewController: UICollectionViewDelegateFlowLayout {
    
    /// size of the item in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numOfCells: CGFloat = 3
        let numOfSpaces: CGFloat = numOfCells + 1 // spaces between the cells left and right
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (spacingBetweenCells * numOfSpaces)) / numOfCells, height: screenHeight * 0.25)
    }
    
    /// insets for collection view - borders at the ENDS of the entire collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacingBetweenCells, left: spacingBetweenCells, bottom: spacingBetweenCells, right: spacingBetweenCells)
    }
    
    /// spacing between rows ^v
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
    
    /// spacing between columns <>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
    
}

