//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let defaults = UserDefaults.standard
    @IBOutlet weak var pickerView: UIPickerView!
    
    var categoriesArray = [Category]() {
        didSet {
            CategoriesKeyedArchiverClient.manager.saveCategories()
            print("Saved Categories to UserDefaults")
            
            for elements in categoriesArray {
                //To print the Categories and see how they are formatted
                //TODO: pick the best property for the BestSellerAPI Call
                print("\(elements.displayName ?? "BLANK") + \(elements.listName ?? "BLANK") + \(elements.listNameEncoded ?? "BLANK")")
            }
            pickerView.reloadAllComponents() //THIS reloads the selector once the data returns from the internet
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
        return "\(categoriesArray[row].displayName ?? "Blank")"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("This is Row: \(row) Component\(component)")
        //TODO: func to set a UserDefault for picker start position
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        loadData()
        
    }
    
    func loadData() {
        
        let CurrentDate = Date()
        print(CurrentDate)
        let plusOneDay: Double = 60*60*24 //One Day in Seconds
        let TomorrowsDate = Date().addingTimeInterval(plusOneDay)
        print(TomorrowsDate)
        
        if CurrentDate == TomorrowsDate
        {
            print("Equal")
        }
        else if CurrentDate > TomorrowsDate
        {
            print("A Day has passed")
            print("CALL API")
            let completion: ([Category]) -> Void = {(onlineCategories: [Category]) in
                self.categoriesArray = onlineCategories
                
                print("Called API for Categories")
            }
            
            CategoriesAPIClient.manager.getCategories(completionHandler: completion, errorHandler: {print($0)})
            print("Save Categories to KeyedArchive")
            print("Set the UserDefault value for DateToCheck to TomorrowsDate")
        }
        else if CurrentDate < TomorrowsDate
        {
            print("A day has not passed")
            print("Load Categories from KeyedArchive")
            // retrieve an array
            if let theCategories = defaults.value(forKey: "Categories") as? [Category] {
                print("Array Retrieved: \(theCategories)")
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let newPickerIndex = String(pickerView.selectedRow(inComponent: 0))
        UserDefaultsHelper.manager.setPickerIndex(to: newPickerIndex)
    }
    
    

    

}
