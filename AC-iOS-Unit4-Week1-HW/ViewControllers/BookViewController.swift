//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    var books = [BookList]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var bookTypes = [BookType]() {
        didSet {
            pickerView.reloadAllComponents()
         
            if let myDefault = UserDefaultHelper.manager.getBook() {
                pickerView.selectRow(myDefault, inComponent: 0, animated: true)
                loadBooks(type: bookTypes[myDefault].name.replacingOccurrences(of: " ", with: "%20"))
            }
        }
    }
        
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self; pickerView.dataSource = self
        collectionView.dataSource = self
        loadBookTypes()
    }
    func loadBookTypes() {
    BookAPIClient.manager.getBookType(completionHandler: {self.bookTypes = $0}, errorHandler: {print($0)})
    }
    func loadBooks(type: String) {
        BookAPIClient.manager.getBookDetail(from: type, completionHandler: {self.books = $0}, errorHandler: {print($0)})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BookDetailViewController {
            if let cell = sender as? BookCollectionViewCell {
                let book = books[(collectionView.indexPath(for: cell)?.row)!]
                destination.googleBook = cell.googleBooks
                destination.selectedBook = book
                destination.bookImage = cell.collectionImageView.image
            }
            }
        }
    }

extension BookViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bookTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bookTypes[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadBooks(type: bookTypes[row].name.replacingOccurrences(of: " ", with: "-"))
    }
}
extension BookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as? BookCollectionViewCell else {return UICollectionViewCell()}
        let book = books[indexPath.row]
        cell.collectionLabel.text = "\(book.duration) Weeks on the best seller List"
        cell.collectionTextView.text = book.details[0].description
        cell.collectionImageView.image = nil
        getDataFromGoogle(with: book.isbns[0].isbn10, cell: cell)
        return cell
    }
    func getDataFromGoogle(with isbn: String, cell: BookCollectionViewCell) {
        GoogleAPIClient.manager.getImages(from: isbn, completionHandler: {let imageURL = $0?[0].volumeInfo.imageLinks?.thumbnail
            if let book = $0 {
                cell.googleBooks = book[0]
            }
            guard let image = imageURL else { cell.collectionImageView.image = #imageLiteral(resourceName: "not-available"); return}
            ImageAPIClient.manager.loadImage(from: image, completionHandler: {cell.collectionImageView.image = $0; cell.collectionImageView.setNeedsLayout()}, errorHandler: {print($0)})
        }, errorHandler: {print($0)})
    }
}


