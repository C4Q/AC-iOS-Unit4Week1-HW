//
//  BestSellersViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Tyler Zhao on 12/14/17.
//  Copyright © 2017 Tyler Zhao. All rights reserved.
//

import UIKit

class BestSellersViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var googleBookInfo: Items?
    
    var pickerData = [Categories]() {
        didSet {
            pickerView.reloadAllComponents()
            pickerView.selectRow(DataModel.selectedPickerRow, inComponent: 0, animated: false)
            loadBestSellers(from: pickerData[DataModel.selectedPickerRow].list_name)
        }
    }
    
    var bestSellers = [BestSellerResults]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        loadPickerData()
    }
    
    //LOAD BESTSELLERS IN CATEGORY AFTER SELECTION FROM PICKERVIEW
    func loadBestSellers(from category: String) {
        let formattedCategoryStr = category.replacingOccurrences(of: " ", with: "-")
        let url = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=9001fc4817314380b77393a05f655409&list=\(formattedCategoryStr)"
        let completion = {(onlineBestSellers: [BestSellerResults]) in
            self.bestSellers = onlineBestSellers
        }
        BestSellerAPIClient.manager.getBestSellers(from: url,
                                                   completionHandler: completion,
                                                   errorHandler: {print($0)})
    }
    
    //LOAD CATEGORIES FOR PICKERVIEW
    func loadPickerData() {
        let url = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=9001fc4817314380b77393a05f655409"
        let completion = {(onlineCategories: [Categories]) in
            self.pickerData = onlineCategories
        }
        CategoriesAPIClient.manager.getCategories(from: url,
                                                  completionHandler: completion,
                                                  errorHandler: {print($0)})
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadBestSellers(from: pickerData[row].list_name)
    }
    
}

//PICKERVIEW METHODS
extension BestSellersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].display_name
    }
}

//COLLECTION VIEW METHODS
extension BestSellersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestSellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! CollectionViewCell
        let bestSeller = bestSellers[indexPath.row]
        
        cell.titleLabel.text = "\(bestSeller.weeks_on_list) weeks on best selling"
        cell.textView.text = bestSeller.book_details.first?.description
        cell.bookImage.image = nil
        
        let url = "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(bestSeller.book_details.first!.primary_isbn13)&key=AIzaSyCYkv2ml0XrhBuNBcQ31pX2qQK30xRB8EU"
        let completion = {(onlineGoogleBooks: Items) in
            if let imageUrl = onlineGoogleBooks.volumeInfo.imageLinks?.thumbnail {
                self.googleBookInfo = onlineGoogleBooks
                print(imageUrl)
                ImageAPIClient.manager.loadImage(from: imageUrl,
                                                 completionHandler: {cell.bookImage.image = $0},
                                                 errorHandler: {print($0)})
            }
        }
        GoogleBookImagesAPIClient.manager.getBestSellers(from: url,
                                                         completionHandler: completion,
                                                         errorHandler: {print($0)})
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BookDetailViewController {
            let cell = sender as! CollectionViewCell
            if let indexPath = collectionView.indexPath(for: cell) {
                destination.book = bestSellers[indexPath.row]
                destination.googleBook = googleBookInfo
                destination.image = cell.bookImage.image
            }
        }
    }
}

extension BestSellersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth - 20, height: collectionView.bounds.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}











