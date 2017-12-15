//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var categories = [Result]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    var books = [Book]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.backgroundColor = UIColor(red:0.59, green:0.65, blue:0.96, alpha:1.00)
            
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            pickerView.dataSource = self
            pickerView.delegate = self
        }
    }
    
    func fetchCategories() {
        CategoryAPIClient.manager.getCategories(from: CategoryModel.shared.categoryEndpoint,
                                                completionHandler: {self.categories = $0.results.sorted{$0.listName < $1.listName}},
                                                errorHandler: {print($0)})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchCategories()
    }
    
}

// MARK: - COLLECTIONVIEW
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}

extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if books.isEmpty {
            collectionView.backgroundView = {
                let newLabel = UILabel()
                newLabel.text = "Pick a category from the picker view! 🔎"
                newLabel.textAlignment = .center
                newLabel.center = collectionView.center
                return newLabel
            }()
            return 0
        } else {
            collectionView.backgroundView = nil
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        let index = indexPath.item
        let book = books[index]
//        dump(book)
        cell.imageView.image = nil
        cell.bestSellingLabel.text = book.bookDetails.first?.title.capitalized
        cell.summaryLabel.text = book.bookDetails.first!.description.isEmpty ? book.bookDetails.first?.description : "No summary!"
        
        let endpoint = "https://www.googleapis.com/books/v1/volumes?q=+isbn:" + ( book.bookDetails.first?.primaryIsbn10 ?? book.isbns.first?.isbn10.description ?? "nil")
        
        var isbnBook: ISBNBook? {
            didSet {
//                print("book is \(isbnBook?.items?.first?.volumeInfo.title)")
                dump(isbnBook)
                ISBNAPIClient.manager.addISBNbook(book: isbnBook!)
                ImageDownloader.manager.getImage(from: isbnBook?.items?.first?.volumeInfo.imageLinks.thumbnail ?? "",
                                                 completionHandler: {cell.imageView.image = UIImage(data: $0); cell.setNeedsLayout()},
                                                 errorHandler: {print($0)})
            }
        }
        
        ISBNAPIClient.manager.fetchISBNBook(from: endpoint,
                                          completionHandler: {isbnBook = $0},
                                          errorHandler: {print($0)})
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let book = ISBNAPIClient.manager.getISBNbooks()[index]
        let alertVC = UIAlertController(title: "Adding " + (books[index].bookDetails.first?.title ?? "No title") , message: "Are you sure?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            KeyedArchiverClient.shared.addFavBook(book: book)
            print(ISBNAPIClient.manager.getISBNbooks().first)
        }))
        alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - PICKERVIEW
extension SearchViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
}

extension SearchViewController: UIPickerViewDelegate {
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].listName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ISBNAPIClient.manager.removeISBNbooks()
        let categoryName = categories[row].listName
        let categoryWithHyphens = categoryName.replacingOccurrences(of: " ", with: "-")
        
        var endpoint = URLComponents(string: "https://api.nytimes.com/svc/books/v3/lists.json")
        endpoint?.queryItems = [
            URLQueryItem(name: "api-key", value: "8e7c1c0a260344af8ea99339ed2f16f4"),
            URLQueryItem(name: "list", value: categoryWithHyphens)
        ]
        
        BookAPIClient.manager.getBooks(from: endpoint?.url?.absoluteString ?? "" ,
                                       completionHandler: {self.books = $0.results},
                                       errorHandler: {print($0)})
    }
}

