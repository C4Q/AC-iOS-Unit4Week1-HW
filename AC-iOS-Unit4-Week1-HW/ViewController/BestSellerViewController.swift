//
//  BestSellerViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

let selectedCategory = "SelectedCategory"
let cellSpacing = UIScreen.main.bounds.size.width * 0.05
var selectedCategoryAtRow = " "

class BestSellerViewController: UIViewController {
    //using this variable just to access the category.key outside the cellforrow at function so i can use that in the loadBooksSellers function
    var categoriesKey = " "
    var bestSellerIsbn = " "
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bestSellersPickerView: UIPickerView!
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.bestSellersPickerView.delegate = self
        self.bestSellersPickerView.dataSource = self
        loadCategories()
        
//
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BestSellerDetailViewController {
//         let selectedBook = collectionView.indexPathsForSelectedItems
            let cell = sender as! CollectionViewCell
            guard collectionView.indexPath(for: cell) != nil else {return}
            destination.book = cell.collectionViewBooks
        }
    }
   
    
    var books = [BooksInfo]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var bestSellers = [BestSellers]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var categories = [AllCategories]() {
        didSet {
            DispatchQueue.main.async {
                self.bestSellersPickerView.reloadComponent(0)
                self.collectionView.reloadData()
            }
        }
    }
    //MARK:- LOAD DATA METHODS
    func loadCategories() {
        guard let url = URL(string:"https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=44b75ac0d27a44b5a98c2919a81ffa76") else {return}
        let completion = {(onlineCategories: [AllCategories]) in
            self.categories = onlineCategories
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        SettingsAPIClient.manager.getCategories(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
    
    func loadBestSellers(fromCategoryName: String) {
        guard let url = URL(string:"https://api.nytimes.com/svc/books/v3/lists.json?api-key=44b75ac0d27a44b5a98c2919a81ffa76&list=\(fromCategoryName)") else {return}
        let completion = {(onlineBestSellers: [BestSellers]) in
            self.bestSellers = onlineBestSellers
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        BestSellersAPIClient.manager.getBestSellers(from: url, completionHandler: completion, errorHandler: {print($0)})
        
    }

    func loadBooks(fromBestSellers bestSeller: BestSellers,
                   completionHandler: @escaping (BooksInfo?) -> Void,
                   errorHandler: @escaping (AppError) -> Void) {
        guard let isbn = bestSeller.isbns.first?.isbn10 else {return}
        guard let url = URL(string:"https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)") else {return}
        let completion = {(onlineBooks: [BooksInfo]) in
           completionHandler(onlineBooks.first)
        }
        let printErrors = {(error: Error) in
            print(error)
        }
    BookDetailAPIClient.manager.getBookDetail(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
    

}
extension BestSellerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(categories.count)
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].categoryName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

       let category = categories[row].key
        loadBestSellers(fromCategoryName: category)
    }
}

extension BestSellerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestSellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellerCell", for: indexPath) as! CollectionViewCell
        let bestSeller = bestSellers[indexPath.row]
//        let book = books[indexPath.row]
//        let category = categories[indexPath.row]
//        categoriesKey = category.key
//        bestSellerIsbn = bestSeller.isbns
        cell.shortDescription.text = bestSeller.bookDetail.description
        cell.numberOfWeeks.text = "\(bestSeller.numberOfWeeks.description) weeks since it has been on the best sellers list"
        loadBooks(fromBestSellers: bestSeller, completionHandler: { (book: BooksInfo?) in
            cell.collectionViewBooks = book
            guard let imageUrlStr = book?.volumeInfo.imageLinks?.thumbnail, let url = URL(string: imageUrlStr) else {return}
            let completion: (Data) -> Void = {(onlineImage: Data) in
                cell.BookImage.image = UIImage(data: onlineImage)
                cell.setNeedsLayout()
            }
            NetworkHelper.manager.performDataTask(with: url , completionHandler: completion, errorHandler: {print($0)})
        }, errorHandler: {print($0)})
      
        
        
        
        return cell
    }
    
   
}

extension BestSellerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

}


