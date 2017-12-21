//
//  BestSellerViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    var books = [BookInfo?](){
        didSet{
         
        
    }
}
    
    
    var bestSellers = [BestSeller](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var categories = [Categories](){
        didSet{
            DispatchQueue.main.async {
                self.pickerView.reloadComponent(0)
                if UserDefaultHelper.manager.getCategory() != nil {
                    self.pickerView.selectRow(UserDefaultHelper.manager.getCategory()!, inComponent: 0, animated: false)
                }else{
                    self.pickerView.selectRow(0, inComponent: 0, animated: false)
                }
            }
        }
    }
    
   
    
    override func viewDidLoad() {
        self.loadCategories()
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
       
    }
    
    
    func loadBestSeller(category: String){
        let urlstr = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=84060264212b4e9c830969fb4684632d&list=\(category)"
        let completion: ([BestSeller]) -> Void = {(onlineBestSeller: [BestSeller]) in
            self.bestSellers = onlineBestSeller
        }
        let errorHanlder: (AppError) -> Void = {(error: AppError) in
            switch error{
            case .noInternetConnection:
                print("best seller: No internet connection")
            case .couldNotParseJSON:
                print("best seller: Could Not Parse")
            case .badStatusCode:
                print("best seller: Bad Status Code")
            case .badURL:
                print("best seller: Bad URL")
            case .invalidJSONResponse:
                print("best seller: Invalid JSON Response")
            case .noDataReceived:
                print("best seller: No Data Received")
            case .notAnImage:
                print("best seller: No Image Found")
            default:
                print("best seller: Other error")
            }
        }
       BestSellerAPIClient.manager.getBestSellers(from: urlstr, completionHandler: completion, errorHandler: errorHanlder)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaultHelper.manager.getCategory() != nil{
            self.pickerView.selectRow(UserDefaultHelper.manager.getCategory()!, inComponent: 0, animated: false)
            if categories.isEmpty{
                return
            }else{
                loadBestSeller(category: categories[UserDefaultHelper.manager.getCategory()!].categoryKey)
            }
        } else{
            
            self.loadBestSeller(category: self.categories[0].categoryKey)
            if categories.isEmpty{
                return
            }else{
                loadBestSeller(category: categories[UserDefaultHelper.manager.getCategory()!].categoryKey)
            }

        }
    }
    
    func loadCategories(){
    let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=84060264212b4e9c830969fb4684632d"
    
        let completion: ([Categories]) -> Void = {(onlineCategories: [Categories]) in
            self.categories = onlineCategories
            if UserDefaultHelper.manager.getCategory() != nil {
                self.loadBestSeller(category: self.categories[UserDefaultHelper.manager.getCategory()!].categoryKey)
            }else{
                self.loadBestSeller(category: self.categories[0].categoryKey)

            }
            
        }
        let errorHanlder: (AppError) -> Void = {(error: AppError) in
            switch error{
            case .noInternetConnection:
                print("categories: No internet connection")
            case .couldNotParseJSON:
                print("categories: Could Not Parse")
            case .badStatusCode:
                print("categories: Bad Status Code")
            case .badURL:
                print("categories: Bad URL")
            case .invalidJSONResponse:
                print("categories: Invalid JSON Response")
            case .noDataReceived:
                print("categories: No Data Received")
            case .notAnImage:
                print("categories: No Image Found")
            default:
                print("categories: Other error")
            }
        }
        CategoryAPIClient.manager.getCategories(from: urlStr, completionHandler: completion, errorHandler: errorHanlder)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        

        return categories[row].categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = categories[row]
        books.removeAll()
        loadBestSeller(category: selectedCategory.categoryKey)
    }
    
}


extension BestSellerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestSellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Best Seller Cell", for: indexPath) as! BestSellerCollectionViewCell
        let bestSellerToSetUp = bestSellers[indexPath.row]
        
        
        if bestSellerToSetUp.numberOfWeeks == 1{
        cell.numberOfWeeks.text = bestSellerToSetUp.numberOfWeeks.description + " week on list"
        }else{
            cell.numberOfWeeks.text = bestSellerToSetUp.numberOfWeeks.description + " weeks on list"
        }
        cell.bookDescription.text = bestSellerToSetUp.bookDetail[0].bestSellerDescription
        
        loadBooks(bestSeller: bestSellerToSetUp, cellToSet: cell, row: indexPath.row)
        
        return cell
    }
    
    
    func loadBooks(bestSeller: BestSeller, cellToSet: BestSellerCollectionViewCell, row: Int){
        print("testfunc")
        
        let isbn = bestSeller.isbns[0].isbn13
        
        let urlStr = "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)&key=AIzaSyDqD8JrNJyYU_ANhQfkiMoItjCAP8X6OdI"
        
        let completion: ([BookInfo]) -> Void = {(onlineGoogleBook: [BookInfo]) in
            print("test")
            if let imageUrl = onlineGoogleBook[0].volumeInfo.imageLinks?.thumbnail{
            
            let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
                cellToSet.bookImage.image = onlineImage
            }
                ImageAPIClient.manager.getImage(from: imageUrl, completionHandler: completion, errorHandler: {cellToSet.bookImage.image = #imageLiteral(resourceName: "image_not_available")
                    print ($0)})
                
            } else{
                cellToSet.bookImage.image = #imageLiteral(resourceName: "image_not_available")
            }
        
            if self.books.isEmpty{
            let newBook = onlineGoogleBook[0]
                self.books.append(newBook) } else{
                if row > self.books.count - 1{
                    let newBook = onlineGoogleBook[0]
                    self.books.append(newBook)
                }
            }
            
        
        
        }
        let errorHanlder: (AppError) -> Void = {(error: AppError) in
            if self.books.isEmpty{
                let nilInfo = Book.init(title: "N/A", subtitle: nil, description: "N/A", imageLinks: nil)
                let nilBook = BookInfo(volumeInfo: nilInfo)
                self.books.append(nilBook)
            } else if row > self.books.count - 1{
            let nilInfo = Book.init(title: "N/A", subtitle: nil, description: "N/A", imageLinks: nil)
            let nilBook = BookInfo(volumeInfo: nilInfo)
                    self.books.append(nilBook)
                    
                }
            
            switch error{
            case .noInternetConnection:
                print("best seller: No internet connection")
            case .couldNotParseJSON:
                print("best seller: Could Not Parse")
                cellToSet.bookImage.image = #imageLiteral(resourceName: "image_not_available")

            case .badStatusCode:
                print("best seller: Bad Status Code333")
            case .badURL:
                print("best seller: Bad URL")
            case .invalidJSONResponse:
                print("best seller: Invalid JSON Response")
            case .noDataReceived:
                print("best seller: No Data Received")
            case .notAnImage:
                print("best seller: No Image Found")
            default:
                print("best seller: Other error")
            }
        }
        
        BookAPIClient.manager.getGoogleBook(from: urlStr, completionHandler: completion, errorHandler: errorHanlder)
        
    }
    
    
    
}


extension BestSellerViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let numCells: CGFloat = 1
            let numSpaces: CGFloat = numCells + 3
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.50)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
