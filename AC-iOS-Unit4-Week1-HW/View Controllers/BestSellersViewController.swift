//
//  BestSellersViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellersViewController: UIViewController {
    
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    
    var bookCategories = [BookCategory]() {
        didSet {
            categoriesPickerView.reloadAllComponents()
            if let index = UserDefaults.standard.value(forKey: UserDefaultsKeys.categoryIndex.rawValue) as? Int {
                categoriesPickerView.selectRow(index, inComponent: 0, animated: true)
            } else {
                UserDefaults.standard.set(0, forKey: UserDefaultsKeys.categoryIndex.rawValue)
            }
        }
    }
    
    var bestSellers = [BestSeller]() {
        didSet {
            booksCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
        categoriesPickerView.delegate = self
        categoriesPickerView.dataSource = self
        loadBookCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard bookCategories.count != 0 else { return }
        if let index = UserDefaults.standard.value(forKey: UserDefaultsKeys.categoryIndex.rawValue) as? Int {
            categoriesPickerView.selectRow(index, inComponent: 0, animated: true)
            BestSellersAPIClient.manager.getBestSellers(with: self.bookCategories[index].list_name, completionHandler: { self.bestSellers = $0 }, errorHandler: { print($0) })
        } else {
            UserDefaults.standard.set(0, forKey: UserDefaultsKeys.categoryIndex.rawValue)
            BestSellersAPIClient.manager.getBestSellers(with: self.bookCategories[0].list_name, completionHandler: { self.bestSellers = $0 }, errorHandler: { print($0) })
        }
    }
    
    func loadBookCategories() {
        BookCategoryAPIClient.manager.getBookCategories(completionHandler: {
            self.bookCategories = $0
            if let index = UserDefaults.standard.value(forKey: UserDefaultsKeys.categoryIndex.rawValue) as? Int {
                BestSellersAPIClient.manager.getBestSellers(with: self.bookCategories[index].list_name, completionHandler: { self.bestSellers = $0 }, errorHandler: { print($0) })
            } else {
                BestSellersAPIClient.manager.getBestSellers(with: self.bookCategories[0].list_name, completionHandler: { self.bestSellers = $0 }, errorHandler: { print($0) })
            }
        }, errorHandler: { print($0) })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBestSellerDetails" {
            let bestSellerDetails = segue.destination as! BestSellerDetailViewController
            let bestSellerCell = sender as! BestSellerCollectionViewCell
            if let indexPath = booksCollectionView.indexPath(for: bestSellerCell) {
                bestSellerDetails.bestSeller = bestSellers[indexPath.row]
            }
        }
    }

}

extension BestSellersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bookCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bookCategories[row].display_name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        BestSellersAPIClient.manager.getBestSellers(with: bookCategories[row].list_name, completionHandler: { self.bestSellers = $0 }, errorHandler: { print($0) })
        UserDefaults.standard.set(row, forKey: UserDefaultsKeys.categoryIndex.rawValue)
    }
    
}

extension BestSellersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestSellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Book Cell", for: indexPath)
        let selectedBook = bestSellers[indexPath.row]
        if let bookCell = bookCell as? BestSellerCollectionViewCell {
            bookCell.weeksInListLabel.text = "\(selectedBook.weeks_on_list) weeks in Best Seller List"
            let bookDescription = selectedBook.book_details[0].description
            if bookDescription == "" { bookCell.bookShortDescription.text = "No short description found." }
            else { bookCell.bookShortDescription.text = bookDescription }
            //bookCell.bookShortDescription.text = selectedBook.book_details[0].description
            bookCell.bookImageView.image = nil
            GoogleBookAPIClient.manager.getGoogleBook(with: selectedBook.book_details[0].primary_isbn13, completionHandler: {
                    ImageFetchHelper.manager.getImage(from: $0.volumeInfo.imageLinks.smallThumbnail, completionHandler: {
                            bookCell.bookImageView.image = $0
                            bookCell.bookImageView.setNeedsLayout()
                        }, errorHandler: { print($0) })
                }, errorHandler: {_ in
                    bookCell.bookImageView.image = #imageLiteral(resourceName: "coverNotFound")
                    bookCell.bookImageView.setNeedsLayout()
                })
        }
        return bookCell
    }
    
}

extension BestSellersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: screenWidth, height: screenHeight * 0.5)
    }
    
}
