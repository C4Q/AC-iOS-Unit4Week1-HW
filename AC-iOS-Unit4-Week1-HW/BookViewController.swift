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
    var text = "" {
        didSet {
            loadBooks()
        }
    }
    var bookTypes = [BookType]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
        
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self
        loadBookTypes()
    }
    func loadBookTypes() {
    BookAPIClient.manager.getBookType(completionHandler: {self.bookTypes = $0}, errorHandler: {print($0)})
    }
    func loadBooks() {
        let bookUrl = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=ef6e801396e44409a1b28aee9dbcd7d4&list=\(text)"
        BookAPIClient.manager.getBookDetail(from: bookUrl, completionHandler: {self.books = $0}, errorHandler: {print($0)})
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
        text = bookTypes[row].name.replacingOccurrences(of: " ", with: "-")
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
        return cell
    }
}
extension BookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375, height: 350)
    }
}

