//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var books = [Book]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Outlets
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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let category = UserDefaultManager.shared.fetchDefault(key: "SavedCategory") {
            if books.isEmpty {
                BookAPIClient.manager.getBooks(from: CategoryAPIClient.manager.endpointForBooksFromCategory(category),
                                               completionHandler: {self.books = $0.results},
                                               errorHandler: {print($0)})
            }
        }
        
    }
    
    func updatePickerToSavedCategory() {
        if let category = UserDefaultManager.shared.fetchDefault(key: "SavedCategory") {
            if let indexOfSavedCategory = CategoryAPIClient.manager.listAllCategories().index(where: {$0.listNameEncoded == category.listNameEncoded}) {
                pickerView.selectRow(indexOfSavedCategory, inComponent: 0, animated: true)
            }
        }
    }
    
    // MARK: - Setup - View/Data
    func fetchCategories() {
        CategoryAPIClient.manager.getCategories(from: CategoryAPIClient.manager.endpointForCategoryList,
                                                completionHandler: { CategoryAPIClient.manager.setCategories($0.results.sorted{$0.listName < $1.listName}); self.pickerView.reloadAllComponents(); self.updatePickerToSavedCategory()},
                                                errorHandler: {print($0)})
    }
    
    // MARK: - Storyboard Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchDetailSegue" {
            let destination = segue.destination as! DetailViewController
            let selectedCell = sender as! BookCell
            let index = collectionView.indexPath(for: selectedCell)!
            let cell = collectionView.cellForItem(at: index) as! BookCell
            destination.selectedBook = books[index.item]
            destination.bookName = cell.bestSellingLabel.text ?? "No title!"
            destination.bookSummary = cell.accessibilityValue ?? "No summary!"
            destination.bookImage = cell.imageView.image
        }
    }
    
    // MARK: - Helper Functions
    func imageFromCell(indexPath: IndexPath) -> UIImage? {
        let cell = collectionView.cellForItem(at: indexPath) as! BookCell
        let image = cell.imageView.image
        return image
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
        cell.summaryLabel.text = book.bookDetails.first?.summary
        
        var isbnBook: ISBNBook? {
            didSet {
                ISBNAPIClient.manager.addISBNbook(book: isbnBook!)
                ImageDownloader.manager.getImage(from: isbnBook?.items?.first?.volumeInfo.imageLinks.thumbnail ?? "",
                                                 completionHandler: {cell.imageView.image = UIImage(data: $0); cell.setNeedsLayout()},
                                                 errorHandler: {print($0)})
                cell.accessibilityValue = isbnBook?.items?.first?.volumeInfo.description
                
            }
        }
        
        if let validISBNEndpoint = ISBNAPIClient.manager.ISBNEndpintFromBook(book) {
            ISBNAPIClient.manager.fetchISBNBook(from: validISBNEndpoint,
                                                completionHandler: {isbnBook = $0},
                                                errorHandler: {print($0)})
        }
        
        if cell.imageView.image == nil {
            cell.imageView.image = #imageLiteral(resourceName: "placeholderImage")
        }
        return cell
    }
}


// MARK: - PICKERVIEW
extension SearchViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CategoryAPIClient.manager.listAllCategories().count
    }
}

extension SearchViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CategoryAPIClient.manager.listAllCategories()[row].listName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ISBNAPIClient.manager.removeISBNbooks()
        let category = CategoryAPIClient.manager.listAllCategories()[row]
        let endpointForBooksFromSelectedCategory = CategoryAPIClient.manager.endpointForBooksFromCategory(category)
        
        BookAPIClient.manager.getBooks(from: endpointForBooksFromSelectedCategory,
                                       completionHandler: {self.books = $0.results},
                                       errorHandler: {print($0)})
    }
    
    
}

