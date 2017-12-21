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
            print("=============== categories SET ===============")
            DispatchQueue.main.async {
                self.bestSellersCategoryPickerView.reloadAllComponents()
            }
        }
    }
    
    var nytBooksWithISBN = [BestSellerBook]() {
        didSet {
            /// do I call NYT API Client here?
            print("=============== nytBooksWithISBN SET ===============")
            DispatchQueue.main.async {
                self.bestSellersCollectionView.reloadData()
            }
        }
    }
    
    var googleBooksWithImages = [BookWrapper]() {
        didSet {
            /// do I call Google Books API Client here?
            print("=============== googleBooksWithImages SET ===============")
            DispatchQueue.main.async {
                self.bestSellersCollectionView.reloadData()
            }
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
    
    func loadCategories() { /// calls NYTAPIClient-Categories, uses NetworkHelper to access data
        // set completion
        let completion: ([Category]) -> Void = {(onlineCategory: [Category]) in
            self.categories = onlineCategory
            print("~~~Categories loaded~~~")
        }
        // set errorHandler
        let errorHandler: (Error) -> Void = {(error: Error) in
            /// TODO: AppError handling
        }
        // API Call
        CategoryAPIClient.shared.getCategories(completionHandler: completion, errorHandler: errorHandler) /// I have the data, this is what I want to do with it
    }
    
    
    
//    func loadCategories(){
//        //set url with endpoint
//        let url = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(APIKeys.NYTAPIKey)"
//        //print(url)
//        //set completion
//        let completion: ([BookCategories]) -> Void = {(onlineCategory: [BookCategories]) in
//            self.categoryArray = onlineCategory //Data becomes an array of categories
//            print("You have categories!")
//        }
//        //set errorHandler
//        let errorHandler: (Error) -> Void = {(error: Error) in
//            //AppError handling
//        }
//        //API call
//        NYTCatogriesAPICleint.manager.getCategories(from: url,
//                                                    completionHandler: completion,
//                                                    errorHandler: errorHandler)
//    }
    
    
    
    
    
    /// segue from collection view cell to detail view
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let destination = segue.destination as? BookDetailViewController {
    //            destination.nytBook = nytBooksWithISBN[bestSellersCollectionView.indexPathsForSelectedItems!.first!.row]
    //            destination.googleBook =
    ///                googleBooksWithImages[bestSellersCollectionView.indexPathsForSelectedItems!.first!.row]
    //
    //        }
    //    }
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
        
        // initialize a nil image
        bookCell.bestSellerImageView.image = nil
        
        // customize WEEKS ON BEST SELLER LIST label
        switch bookWithISBN.weeksOnList {
        case 1:
            bookCell.weeksOnListLabel.text = "\(bookWithISBN.weeksOnList) Week On Best Sellers List"
        default:
            bookCell.weeksOnListLabel.text = "\(bookWithISBN.weeksOnList) Weeks On Best Sellers List"
        }
        
        // load book short description
        bookCell.shortDescriptionTextView.text = bookWithISBN.bookDetails[0].shortDescription
        
        // calls load Image function
        loadBookDetails(with: bookWithISBN.isbns[0].isbn10!, cell: bookCell)
        
        return bookCell
    }
    
    
    /// load images from google
    
    // call function to populate Google array in the nytBooksWithISBN didSet
    
    // populate Google Array:
    // 1) Check each ISBN number from nytBooksWithISBN
    
    func loadBookDetails(with isbn: String, cell: BestSellerCollectionViewCell) {
        //        BookDetailGoogleAPIClient.shared.getBookDetails(isbn: isbn,
        //               completionHandler: { let imageURL = $0[0].volumeInfo.imageLinks.thumbnail
        //                                            ImageAPIClient.manager.loadImage(from: imageURL, completionHandler: {cell.bestSellerImageView.image = $0; cell.bestSellerImageView.setNeedsLayout() }, errorHandler: {print($0)}) }, errorHandler: {print($0)})
        //    }
        // 2) Find image in googleBooksWithImages using the ISBN number
        // 3) Load the image attribute to the nytBooksWithISBN to load the collection view cell
        
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
        
        /// populating the Best Seller Book info
        BestSellerBookAPIClient.shared.getNYTBooks(category: category.listNameEncoded , completionHandler: completion, errorHandler: {print($0)})
    }
}




let spacingBetweenCells = UIScreen.main.bounds.size.width * 0.05

/// format the Best Seller collection view

extension BestSellersViewController: UICollectionViewDelegateFlowLayout {
    
    /// size of the item in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numOfCells: CGFloat = 1
        let numOfSpaces: CGFloat = numOfCells + 1 // spaces between the cells left and right
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (spacingBetweenCells * numOfSpaces)) / numOfCells, height: screenHeight * 0.50) // this Double changes the height of the cells
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
