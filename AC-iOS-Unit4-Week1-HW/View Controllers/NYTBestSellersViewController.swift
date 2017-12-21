//
//  NYTBestSellersViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
//Getting book BY the isbn number

class NYTBestSellersViewController: UIViewController {
    
    //MARK: - outlets
    @IBOutlet weak var bestSellersTableView: UITableView!
    
    //MARK: - variables for VC
    let cellSpacing: CGFloat = 20.0 //creating constant for the cell spacing
    
    //What is powering the app
    var bestSellers = [BestSellers](){
        didSet{
            //save to archiver
        }
    }
    var categories = [BookCategories](){
        didSet{
            // save to archiver
            
//            //array of
//            for element in categories{
//                NYTCategoriesAPIClient.manager.getCategories(completionHandler: completion,
//                                                             errorHandler: {print($0)})
//                print(element.categoryName)
//            }
            bestSellersTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Delegates
        bestSellersTableView.delegate = self
        bestSellersTableView.dataSource = self
        
        //MARK: - Using UserDefaults to check the date and call API nad store data or call the Archiver
        //if the first api call happened run the date checker function
        if DatesUserDefaultsHelper.manager.getDidFirstAPICallHappenYet() == false {
            //MARK: - Loading Data
            loadCategories() //makes the api call
            loadBestSellers() // depending on if data is stored, bestsellers will either call archiver to get stored data from phone or it will make the api call and save that data to the phone
            print("First call made and NYT data has been stored")
        } else {
            //call Date checker
            DateChecker.manager.NYTBestSellersAPIDateCheck()
            //store that NYT data into archiver
        }
    }
    
    //MARK: - Getting an array of Categories from data
    func loadCategories(){
        //set completion
        let completion: ([BookCategories]) -> Void = {(onlineCategory: [BookCategories]) in
            self.categories = onlineCategory //Data becomes an array of categories
            print("You have categories!")
        }
        //set errorHandler
        let errorHandler: (Error) -> Void = {(error: Error) in
            //AppError handling
        }
        //API call
        NYTCategoriesAPIClient.manager.getCategories(completionHandler: completion,
                                                     errorHandler: errorHandler)
    }
    
    //MARK: - Getting best sellers from data
    func loadBestSellers(){
        //set completion
        let completion: ([BestSellers]) -> Void = {(onlineBook: [BestSellers]) in
            self.bestSellers = onlineBook
            print("You have books!")
        }
        //errorHandler
        let errorHandler: (Error) -> Void = {(error: Error) in
            //AppError
        }
        
        //check if data is already stored
        //if yes == make archiver call and load data from phone
        //if no == makes api call and save to archiver
        //API call
        NYTBestSellersAPIClient.manager.getBestSellerISBN(from: url,
                                                          completionHandler: completion,
                                                          errorHandler: errorHandler)
    }
}


//MARK: - Table Views of Categories
extension NYTBestSellersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bestSellersTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? BooksTableViewCell else {
            return UITableViewCell()
        }
        let category = categories[indexPath.row]
        
            cell.categoryLabel.text = category.categoryName
        return cell
    }
    
    
}

//MARK: - CollectionView of books by Category
extension NYTBestSellersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
//
//        //let bestSeller = bestSellers[indexPath.row]
//        //bestSeller.bookDetails[0].author
//        cell.onlineBookImage.image = #imageLiteral(resourceName: "bookImg")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//MARK: Manipulation CollectionView cellsizing
extension NYTBestSellersViewController: UICollectionViewDelegateFlowLayout {
    
    //returns how large the cells should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 9//number of cells visible in row
        let numSpace: CGFloat = numCells + 5.5
        let screenWidth = UIScreen.main.bounds.width  // screen width fo the device
        //print("cells are large enough!")
        //cgsize expects a tuple: (width, height)
        //returns item size
        return CGSize(width:(screenWidth-(cellSpacing * numSpace)), height: collectionView.bounds.height - (cellSpacing * 2))
        //return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 2)
    }
    
    //returns padding around the collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
    }
    
    //returns padding between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}



