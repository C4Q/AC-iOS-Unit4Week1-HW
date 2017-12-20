//
//  BestSellerViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //constant for our cell spacing which will be consistent around  our cells
    let cellSpacing: CGFloat = 20.0
    
    
    
    var categoriesArray = [Category]() {
        didSet {
            CategoriesKeyedArchiverClient.manager.addAllCategories(allCategories: categoriesArray)
            
            //for element in categoriesArray {
                //Call API with element.theEndpointLink
                //Save each category
                //Only run this once in Friday OR if the app never ran before
                //All other times load from saved data
            //}
            
            pickerView.reloadAllComponents() //THIS reloads the selector once the data returns from the internet
            CategoriesKeyedArchiverClient.manager.saveCategories()
            print("Saved Categories to KeyedArchive")
        }
    }
    var displayedBestSellers = [BestSellers]() {
        didSet {
            BestSellersKeyedArchiverClient.manager.addBestSellersArray(BestSellers: displayedBestSellers)
            collectionView.reloadData()
            for elements in displayedBestSellers {
                print(elements.bookDetails[0].title)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        loadPickerView()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pickerIndex = UserDefaultsHelper.manager.getPickerIndex() {
            pickerView.selectRow(Int(pickerIndex), inComponent: 0, animated: true)
        }
        pickerView.reloadComponent(0)
        
    }
    
    func loadPickerView() {
        let plusOneDay: Double = 60*60*24 //One Day in Seconds
        let newTomorrowDate = Date().addingTimeInterval(plusOneDay)
        if UserDefaultsHelper.manager.didItRunAtLeastOnce() == true {
            print("A day has not passed")
            print("Load Categories from KeyedArchive")
            CategoriesKeyedArchiverClient.manager.loadCategories()
            self.categoriesArray = CategoriesKeyedArchiverClient.manager.getCategories()
        } else {
            print("First Time running app")
            print("Call API for Categories")
            let completion: ([Category]) -> Void = {(onlineCategories: [Category]) in
                self.categoriesArray = onlineCategories
                
                print("Finished API CAll for Categories")
            }
            
            CategoriesAPIClient.manager.getCategories(completionHandler: completion, errorHandler: {print($0)})
            
            //To stop the API calls until tomorrow
            UserDefaultsHelper.manager.setTomorrowDate(to: newTomorrowDate)
            //To confirm the app has run at least once
            UserDefaultsHelper.manager.setRanAtLeastOnce(to: true)
        }
        if let pickerIndex = UserDefaultsHelper.manager.getPickerIndex() {
            pickerView.selectRow(Int(pickerIndex), inComponent: 0, animated: true)
        }
    }
    func loadData() {
        //This is to set the BestSellersCollectionView to the last Category the PickerView was on when the screen loads
        
        let startingPickerIndex = pickerView.selectedRow(inComponent: 0)
        let firstLoadedCategory = categoriesArray[startingPickerIndex]
        let endPointForCategory = firstLoadedCategory.theEndpointLink
        
        let completion: ([BestSellers]) -> Void = {(onlineBestSellers: [BestSellers]) in
            
            self.displayedBestSellers = onlineBestSellers //This should trigger the didSet and add to the Best Seller Array
            print("Finished API CAll for Best Sellers in \(firstLoadedCategory.displayName)")
            BestSellersKeyedArchiverClient.manager.saveBestSellers(encoded: firstLoadedCategory.listNameEncoded)
            print("Best Seller for \(firstLoadedCategory.displayName) saved to phone")
        }
        
        BestSellersAPIClient.manager.getBestSellers(matching: endPointForCategory, completionHandler: completion, errorHandler: {print($0)})
    }
    
    
    
    //MARK: PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(categoriesArray[row].displayName)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("This is Row: \(row) Component\(component)")
        
        let newPickerIndex = String(pickerView.selectedRow(inComponent: 0))
        UserDefaultsHelper.manager.setPickerIndex(to: newPickerIndex)
        print("New Saved Picker Index is \(newPickerIndex)")
        
        let selectedCategory = categoriesArray[pickerView.selectedRow(inComponent: 0)]
        let endpoint = selectedCategory.theEndpointLink
        
        //THIS IS WHERE THE BEST SELLER API IS CALLED
        BestSellersKeyedArchiverClient.manager.loadData(encoded: selectedCategory.listNameEncoded)
        //If a value for the endpoint returns nil from the archiver, call the API ELSE load from archive
        if BestSellersKeyedArchiverClient.manager.getBestSellers().isEmpty {
            //API CALL GOES HERE
            let completion: ([BestSellers]) -> Void = {(onlineBestSellers: [BestSellers]) in
                self.displayedBestSellers = onlineBestSellers //This should trigger the didSet and add to the Best Seller Array
                print("Finished API CAll for Best Sellers in \(selectedCategory.displayName)")
                BestSellersKeyedArchiverClient.manager.saveBestSellers(encoded: selectedCategory.listNameEncoded)
                print("Best Seller for \(selectedCategory.displayName) saved to phone")
            }
            BestSellersAPIClient.manager.getBestSellers(matching: endpoint, completionHandler: completion, errorHandler: {print($0)})
        } else {
            self.displayedBestSellers = BestSellersKeyedArchiverClient.manager.getBestSellers()
        }
    }
}
//MARK: Collection View Delegate and DataSource
extension BestSellerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedBestSellers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "booksCell", for: indexPath) as? BestSellerCollectionViewCell else {return UICollectionViewCell() }
        
        let aBook = displayedBestSellers[indexPath.row]
        cell.shortDescriptionLabel.text = aBook.bookDetails[0].description
        cell.weeksOnBestSellerLabel.text = "Weeks On: \(aBook.weeksOnList)"
        
        //IMAGE API HERE
        //ADD SAVE IMAGE TO DETAILEDVIEWCONTROLLER. NOT HERE.
        
        
        return cell
        
    }
    
    //FLOW LAYOUT DELEGATES
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2.0 // cells visible in row
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width // screen width of the device
        
        //return item size
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: collectionView.bounds.height - (cellSpacing * 2))
    }
    
    //Padding around collection cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

