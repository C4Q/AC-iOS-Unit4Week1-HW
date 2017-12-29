//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit


let defaults = UserDefaults.standard


class BestSellersViewController: UIViewController {
    
    @IBOutlet weak var bestSellersCollectionView: UICollectionView!
    @IBOutlet weak var bestSellersCategoryPickerView: UIPickerView! {
        didSet {
            print("Settings Start Category Loaded")
        }
    }
    
    var categories = [Category]() {
        didSet {
            /// load initialized by func loadCategories
            print("=============== categories SET ===============")
                self.bestSellersCategoryPickerView.reloadAllComponents()
                if let settingsCategory = defaults.value(forKey: "selectedCategoryIndexKey") as? Int { self.bestSellersCategoryPickerView.selectRow(settingsCategory, inComponent: 0, animated: false)
            }
        }
    }
    
    var nytBooksWithISBN = [BestSellerBook]() {
        didSet {
            /// load initialized in the Category pickerView delegate didSelectRow
            print("=============== nytBooksWithISBN SET ===============")
                self.bestSellersCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bestSellersCollectionView.dataSource = self
        self.bestSellersCollectionView.delegate = self
        self.bestSellersCategoryPickerView.dataSource = self
        self.bestSellersCategoryPickerView.delegate = self
        loadCategories()
    }
    
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        bestSellersCollectionView.reloadData()
        bestSellersCategoryPickerView.reloadAllComponents()
    }
    
    func loadCategories() { /// calls NYTAPIClient-Categories, uses NetworkHelper to access data
        // set completion
        let completion: ([Category]) -> Void = {(onlineCategory: [Category]) in
            self.categories = onlineCategory
        }
        // set errorHandler
        let errorHandler: (Error) -> Void = {(error: Error) in
            /// TODO: AppError handling
        }
        // API Call
        CategoryAPIClient.shared.getCategories(completionHandler: completion, errorHandler: errorHandler)
    }
    
    
    
    /// TODO: segue from collection view cell to detail view
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BookDetailViewController {
            if let cell = sender as? BestSellerCollectionViewCell {
                if let selectedIndexPath = self.bestSellersCollectionView.indexPathsForSelectedItems?[0] {
                    let row = selectedIndexPath.row
                    let selectedBook = nytBooksWithISBN[row]
                    
                    destination.detailedBook = selectedBook
                    destination.myGoogleBook = cell.myGoogleBook
                    destination.bookImage = cell.bestSellerImageView.image
                }
            }
        }
    }
    
    
    
    
}


/// BEST SELLERS COLLECTION VIEW DATASOURCE

extension BestSellersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookCell = bestSellersCollectionView.dequeueReusableCell(withReuseIdentifier: "Book Cover Cell", for: indexPath) as! BestSellerCollectionViewCell
        let bookWithISBN = nytBooksWithISBN[indexPath.row]
        
        // customize WEEKS ON BEST SELLER LIST label
        switch bookWithISBN.weeksOnList {
        case 1:
            bookCell.weeksOnListLabel.text = "\(bookWithISBN.weeksOnList) Week On Best Sellers List"
        default:
            bookCell.weeksOnListLabel.text = "\(bookWithISBN.weeksOnList) Weeks On Best Sellers List"
        }
        
        // load book short description
        bookCell.shortDescriptionTextView.text = bookWithISBN.bookDetails[0].shortDescription
        
        // initialize a nil image
        bookCell.bestSellerImageView.image = nil
        
        /// calls load Image function
        loadBookDetails(from: bookWithISBN, cell: bookCell)
        
        return bookCell
    }
    
    
    
    
    /// load images from google
    
    func loadBookDetails(from book: BestSellerBook, cell: BestSellerCollectionViewCell) {
        
        // import isbn from the book
        guard let isbn = book.isbns[0].isbn13 else {
            return
        }
        
        BookDetailGoogleAPIClient.shared.getBookDetails(isbn: isbn, completionHandler: {
            guard let details = $0 else {return} // populates the individual book details
            guard let imageURL = details[0].volumeInfo.imageLinks?.thumbnail else {return}
            
            cell.myGoogleBook = details[0]
            
            ImageAPIClient.manager.loadImage(from: imageURL, completionHandler: {
                cell.bestSellerImageView.image = $0
                cell.setNeedsLayout()
                
            }, errorHandler: {print("loading images from google error: \($0)")})
            
        }, errorHandler: {print("loading images from google error: \($0)")})
        
    }
    
}








/// PICKER VIEW DELEGATES

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
    
    
    /// load CollectionView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let category = categories[row]
        
        let completion: ([BestSellerBook]) -> Void = {(onlineBestSellers: [BestSellerBook]) in
            self.nytBooksWithISBN = onlineBestSellers
        }
        /// CALLS NYT BEST SELLERS API CLIENT, loads the NYT Book data
        BestSellerBookAPIClient.shared.getNYTBooks(category: category.listNameEncoded,
                                                   completionHandler: completion,
                                                   errorHandler: {print($0)})
    }
}





/// FORMAT BEST SELLERS COLLECTION VIEW CELLS

let spacingBetweenCells = UIScreen.main.bounds.size.width * 0.05

extension BestSellersViewController: UICollectionViewDelegateFlowLayout {
    
    /// size of the item in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numOfCells: CGFloat = 1
        let numOfSpaces: CGFloat = numOfCells + 1 // spaces between the cells left and right
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (spacingBetweenCells * numOfSpaces)) / numOfCells, height: screenHeight * 0.45) // this Double changes the height of the cells
    }
    
    /// insets for collection view - borders at the ENDS of the entire collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacingBetweenCells, left: spacingBetweenCells, bottom: spacingBetweenCells, right: spacingBetweenCells)
    }
    
    /// spacing between rows ^v
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /// spacing between columns <>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
    
}
