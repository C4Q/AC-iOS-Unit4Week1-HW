//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var categoriesArray = [Categories]() {
        didSet {
            for elements in categoriesArray {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        loadData()
        
    }
    
    func loadData() {
        /*
        let CurrentDate = Date()
        print(CurrentDate)
        var plusOneDay: Double = 60*60*24 //One Day in Seconds
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
            print("Save Categories to KeyedArchive")
            print("Set the UserDefault value for DateToCheck to TomorrowsDate")
        }
        else if CurrentDate < TomorrowsDate
        {
            print("A day has not passed")
            print("Load Categories from KeyedArchive")
        }
        
        //If the date is different from today do this
        */
        
        
        let completion: ([Categories]) -> Void = {(onlineCategories: [Categories]) in
            self.categoriesArray = onlineCategories
            //Add funcKeyedArchiverSaver here to Save Categories
            //print("Called API for Categories")
        }
        
        CategoriesAPIClient.manager.getCategories(completionHandler: completion, errorHandler: {print($0)})
        
        
        
        //ELSE Load the data up from the Keyed Archiver
        
        //print("Categories loaded from KeyedArchive")
        //func to load from KSKeyedArchive
        
        
        
        
        
    }

    
    

    

}
