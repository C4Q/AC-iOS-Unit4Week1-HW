//
//  BestSellersViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellersViewController: UIViewController {
    
    @IBOutlet weak var catPickerView: UIPickerView!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
//    let APIKeyNYT = "9f39668c8c0d4aadbd3e97a30c45e5c7"
//    let urlNYT = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key="
    var catBooks = [Book]() {
        didSet {
            self.catPickerView.reloadAllComponents()
            if let index = BooksAPIClient.manager.getSetting() {
                self.catPickerView.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    var books = [Book]() {
        didSet {
            self.bookCollectionView.reloadData()
        }
    }
    let cellSpacing: CGFloat = 10.0
    var bookImages = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.catPickerView.delegate = self
        self.catPickerView.dataSource = self
        self.bookCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCategories()
    }
    
    func loadCategories() {
        let loadData: ([Book]) -> Void = {(onlineBook: [Book]) in
            self.catBooks = onlineBook
        }
        let url = BooksAPIClient.urlNYT + BooksAPIClient.APIKeyNYT
        BooksAPIClient.manager.getBooks(from: url,completionHandler: loadData, errorHandler: {print($0)})
    }
    
    func loadBooks(from category: String) {
        let url = "https://api.nytimes.com/svc/books/v3/lists.json?list=\(category)&api-key=" + BooksAPIClient.APIKeyNYT
        let loadData: ([Book]) -> Void = {(onlineBook: [Book]) in
            self.books = onlineBook
        }
        BooksAPIClient.manager.getBooks(from: url,completionHandler: loadData, errorHandler: {print($0)})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bookDVC = segue.destination as? DetailViewController {
            let book = books[(self.bookCollectionView.indexPathsForSelectedItems?.first!.row)!]
            bookDVC.book = book
        }
    }
}

extension BestSellersViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catBooks[row].listName ?? "No Category found"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var category = catBooks[row].listName ?? catBooks[row].displayName!
        category = category.replacingOccurrences(of: " ", with: "-")

        loadBooks(from: category)
    }
}

extension BestSellersViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catBooks.count
    }
    
}

extension BestSellersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width // screen width of device
        
        // retrun item size
        return CGSize(width: screenWidth, height: collectionView.bounds.height)
    }
    
    
}

extension BestSellersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.bookCollectionView.dequeueReusableCell(withReuseIdentifier: "Book Cell", for: indexPath) as? BestSellersCollectionViewCell {
            let book = books[indexPath.row]
            cell.rankLastWeekLabel.text = "\(book.rankLastWeek ?? 0) weeks on the best seller list"
            if let detail = book.bookDetails {
                cell.descriptionLabel.text = detail.first?.description ?? ""
            }
            cell.bookImageView.image = nil
            //
            var urlStr = "https://www.googleapis.com/books/v1/volumes?q=+isbn:"
            if let myISBNS = book.bookDetails  {
                urlStr += myISBNS.first!.primaryISBN13
                let getBookFromISBN: ([Book]) -> Void = {(onlineImageBook) in
                    if let volume = onlineImageBook[0].volumeInfo, let image = volume.imageLinks {
                        BooksAPIClient.manager.getImage(from: image.smallThumbnail, completionHandler: {cell.bookImageView.image = $0}, errorHandler: {print($0)})
                    }
                }
                BooksAPIClient.manager.getBooks(from: urlStr, completionHandler: getBookFromISBN, errorHandler: {print($0)})
                cell.bookImageView.setNeedsLayout()
            
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

