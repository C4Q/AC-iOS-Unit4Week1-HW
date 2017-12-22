//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerViewController: UIViewController {

    @IBOutlet weak var bestSellerCollectionView: UICollectionView!
    
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    
    let cellSpacing: CGFloat = UIScreen.main.bounds.width * 0.20
    
    var categories: [String] = [] {
        didSet {
            let currentCategory = categories[self.categoriesPickerView.selectedRow(inComponent: 0)]
            
            self.loadBestSellers(withCategory: currentCategory)
            categoriesPickerView.reloadComponent(0)
        }
    }
    
    var bestSellers: [BestSeller] = [] {
        didSet {
           bestSellerCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        categoriesPickerView.delegate = self
        categoriesPickerView.dataSource = self
        bestSellerCollectionView.delegate = self
        bestSellerCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let categoryIndex = Settings.getCategory(), Settings.categoryChanged {
            categoriesPickerView.selectRow(categoryIndex, inComponent: 0, animated: true)
            categoriesPickerView.reloadComponent(0)
        }
        
    }
    
    func loadCategories() {
        self.categories = CategoryData.manager.getCategories()
        
        if categories.isEmpty {
            CategoryAPIClient.manager.getCategories(completionHandler: { (onlineCategories) in
                
                let categories = onlineCategories.map{$0.listName}.sorted{$0 < $1}
                CategoryData.manager.addCategories(categories)
                
                self.categories = CategoryData.manager.getCategories()
                
            }, errorHandler: { (appError) in
                self.presentErrorAlert(forError: appError)
            })
        }
    }
    
    func loadBestSellers(withCategory category: String) {
        
        if let bestSellers = BestSellerData.manager.getBestSellers(inCategory: category) {
            
            self.bestSellers = bestSellers
            return
        }
        
        BestSellerAPIClient.manager.getBestSellers(forCategory: category, completionHandler: { (onlineBestSellers) in
            BestSellerData.manager.saveBestSellers(onlineBestSellers, inCategory: category)
            
            self.bestSellers = onlineBestSellers
            
        }, errorHandler: { (appError) in
            self.presentErrorAlert(forError: appError)
        })
    }
    
    func presentErrorAlert(forError error: Error) {
        let alertController = Alert.createAlert(forError: error)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension BestSellerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Settings.categoryChanged = false
        
        let currentCategory = categories[row]
        
        loadBestSellers(withCategory: currentCategory)
    }
}

extension BestSellerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
}

extension BestSellerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 1
        let numberOfSpaces: CGFloat = numberOfCells + 1
        let width = (collectionView.bounds.width - (numberOfSpaces * cellSpacing)) / numberOfCells
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
}

extension BestSellerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestSellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bestSellerCell", for: indexPath) as! BestSellerCollectionViewCell
        
        let currentBestSeller = bestSellers[indexPath.row]
        
        cell.configureCell(withBestSeller: currentBestSeller)
        
        //I know we shouldn't make the cell do so much stuff (like doing network requests to get a whole model), but I couldn't get the right google book image to load for the corresponding best seller other wise (the google books and the best sellers were never in the same order in the array) - I don't know how to use dispatch group yet, so for now I can only do this
        //loading google book
        GoogleBookAPIClient.manager.getGoogleBooks(
            forISBN: currentBestSeller.bookDetails[0].isbn10,
            completionHandler: { (googleBook) in
                cell.configureImageForCell(withGoogleBook: googleBook) { (appError) in
                    self.presentErrorAlert(forError: appError)
                }
        },
            errorHandler: { (appError) in
                self.presentErrorAlert(forError: appError)
        })
        
        return cell
    }
}
