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
    
    var categoriesArray = [Category]() {
        didSet {
            CategoriesKeyedArchiverClient.manager.addAllCategories(allCategories: categoriesArray)
            
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
        //TODO: ADD OUTLETS AND DELEGATES
        loadPickerView()
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
            
            UserDefaultsHelper.manager.setTomorrowDate(to: newTomorrowDate)
            UserDefaultsHelper.manager.setRanAtLeastOnce(to: true)
        }
        if let pickerIndex = UserDefaultsHelper.manager.getPickerIndex() {
            pickerView.selectRow(Int(pickerIndex), inComponent: 0, animated: true)
        }
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
        
        BestSellersKeyedArchiverClient.manager.loadData(encoded: selectedCategory.listNameEncoded)
        //If a value for the endpoint returns nil from the archiver, call the API ELSE load from archive
        if BestSellersKeyedArchiverClient.manager.getBestSellers().isEmpty {
            //API CALL GOES HERE
            let completion: ([BestSellers]) -> Void = {(onlineBestSellers: [BestSellers]) in
                self.displayedBestSellers = onlineBestSellers //This should trigger the didSet and add to the Best Seller Array
                print("Finished API CAll for Best Sellers in \(selectedCategory.displayName)")
                BestSellersKeyedArchiverClient.manager.saveBestSellers(encoded: selectedCategory.listNameEncoded)
            }
            BestSellersAPIClient.manager.getBestSellers(matching: endpoint, completionHandler: completion, errorHandler: {print($0)})
        } else {
            self.displayedBestSellers = BestSellersKeyedArchiverClient.manager.getBestSellers()
        }
    }
}
