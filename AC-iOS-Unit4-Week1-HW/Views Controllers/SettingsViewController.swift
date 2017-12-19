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
            CategoriesKeyedArchiverClient.manager.addAllCategories(allCategories: categoriesArray)
//            for elements in categoriesArray {
//                //To print the Categories and see how they are formatted
//                print("\(elements.displayName) + \(elements.listName ?? "BLANK") + \(elements.listNameEncoded)")
//            }
            pickerView.reloadAllComponents() //THIS reloads the selector once the data returns from the internet
            CategoriesKeyedArchiverClient.manager.saveCategories()
            print("Saved Categories to KeyedArchive")
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
        let newTomorrowDate = Date().addingTimeInterval(plusOneDay)
        var storedDate = Date()
        if let check = UserDefaultsHelper.manager.getTomorrowDate(){
             storedDate = check
        } else {
             storedDate = newTomorrowDate
        }
        if CurrentDate == storedDate { print("Equal")
        }
        else if CurrentDate > storedDate
        {
            print("A Day has passed. CALL API")
            let completion: ([Category]) -> Void = {(onlineCategories: [Category]) in
                self.categoriesArray = onlineCategories
                
                print("Called API for Categories")
            }
            
            CategoriesAPIClient.manager.getCategories(completionHandler: completion, errorHandler: {print($0)})
            print("Set the UserDefault value for DateToCheck to TomorrowsDate")
            UserDefaultsHelper.manager.setTomorrowDate(to: newTomorrowDate)
        }
        else if CurrentDate < storedDate
        {
            if UserDefaultsHelper.manager.didItRunAtLeastOnce() == true {
                print("A day has not passed. Load Categories from KeyedArchive")
                CategoriesKeyedArchiverClient.manager.loadCategories()
                self.categoriesArray = CategoriesKeyedArchiverClient.manager.getCategories()
            } else {
                print("First Time running app")
                let completion: ([Category]) -> Void = {(onlineCategories: [Category]) in
                    self.categoriesArray = onlineCategories
                    
                    print("Called API for Categories")
                }
                
                CategoriesAPIClient.manager.getCategories(completionHandler: completion, errorHandler: {print($0)})
                print("Set the UserDefault value for DateToCheck to TomorrowsDate")
                UserDefaultsHelper.manager.setTomorrowDate(to: newTomorrowDate)
                UserDefaultsHelper.manager.setRanAtLeastOnce(to: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let newPickerIndex = String(pickerView.selectedRow(inComponent: 0))
        UserDefaultsHelper.manager.setPickerIndex(to: newPickerIndex)
        print("New Picker Index is \(newPickerIndex)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pickerIndex = UserDefaultsHelper.manager.getPickerIndex() {
            pickerView.selectRow(Int(pickerIndex), inComponent: 0, animated: true)
        }
    }
}
