//
//  BestSellerViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//


import UIKit

class BestSellerViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    // MARK: - variables
    var bookImage: UIImage!
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    var categories = [CategoryResults]() {
        didSet {
            categoryPicker.reloadAllComponents()
            PickerCategories.setCategories(from: categories)
            setDefaultRowForPicker()
        }
    }
    
    var bestSellerBooks = [Book]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - viewDidLoad overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        loadCategories()
    }
    
    // MARK: - functions
    func loadCategories() {
        NYTimesAPIClient.manager.getBestSellerCategories(completion: { self.categories = $0 }, errorHandler: { print($0) })
        // TO DO: call loadDefaultCategory()
        
    }
    
    func loadDefaultCategory(){
        // TO DO: Set picker to default if value is available after call
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookDetails" {
            let detailVC = segue.destination as! BookDetailViewController
            let cell = sender as! BestSellerCell
            if let indexPath = collectionView.indexPath(for: cell) {
                detailVC.bookImageView.image = bookImage
                detailVC.bookTextView.text =
            }
        }
    }
    
    func setDefaultRowForPicker() {
        guard let index = categories.index(where: {$0.displayName == UserDefaultsHelper.manager.getDefaultBookCategory() ?? ""}) else { return }
        categoryPicker.selectRow(index, inComponent: 0, animated: false)
         NYTimesAPIClient.manager.getBestSellerBooks(for: categories[index].listNameEncoded, completion: {self.bestSellerBooks = $0}, errorHandler: { print($0) })
    }
    
}

// MARK: - PickerView
extension BestSellerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // numberOfRowsInComponent
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
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
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellerCell", for: indexPath) as! BestSellerCell
        let book = bestSellerBooks[indexPath.row]
        cell.bookWeeksLabel.text = "\(book.weeks_on_list?.description ?? "0") weeks on the best seller list."
        cell.bookTextView.text = book.book_details[indexPath.section].description ?? "No description available at this time."
        
        // set to nil to avoid image flicker
        cell.bookImageView.image = nil
        getBookData(from: book, for: cell)
        return cell
    }
    
    // Gets book details for image and long description.
    func getBookData(from book: Book, for cell: BestSellerCell) {
        let isbn = book.book_details[0].primary_isbn13
        
        // using ISBN13 api client gets data. If nil, image is set to default "stashNoImage"
     GoogleAPIClient.manager.getBookDetails(for: isbn, completion: {
        
        //if array is nil, image is set to default "stashNoImage"
        guard let bookdetails = $0 else { cell.bookImageView.image = #imageLiteral(resourceName: "StashNoImage");  return }
        guard let imageURL = bookdetails[0].volumeInfo.imageLinks?.thumbnail else { cell.bookImageView.image = #imageLiteral(resourceName: "StashNoImage"); return  }
        ImageAPIClient.manager.loadImage(from: imageURL, completionHandler: {
                cell.bookImageView.image = $0
                cell.setNeedsLayout() }, errorHandler: { print($0) })
        }, errorHandler: { print($0) })
    }
}



// MARK: CollectionView
extension BestSellerViewController: UICollectionViewDelegateFlowLayout {
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 400)
    }
}


    
    
    
    
    
    
    
    
    //    //inset for section at
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    //    }
    //
    //    //minimum line Spacing for section
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return cellSpacing
    //    }
    //
    //    //minimum Inter item spacing for spacing for section
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return cellSpacing
    //    }
