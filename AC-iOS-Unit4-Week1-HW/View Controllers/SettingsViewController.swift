//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var categories = [Categories](){
        didSet{
            pickerView.reloadAllComponents()
            if UserDefaultHelper.manager.getCategory() != nil{
                self.pickerView.selectRow(UserDefaultHelper.manager.getCategory()!, inComponent: 0, animated: false)
            } else{
                self.pickerView.selectRow(7, inComponent: 0, animated: false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        loadCategories()
    }

    func loadCategories(){
        let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=84060264212b4e9c830969fb4684632d"
        
        let completion: ([Categories]) -> Void = {(onlineCategories: [Categories]) in
            self.categories = onlineCategories
        }
        let errorHanlder: (AppError) -> Void = {(error: AppError) in
            switch error{
            case .noInternetConnection:
                print("categories: No internet connection")
            case .couldNotParseJSON:
                print("categories: Could Not Parse")
            case .badStatusCode:
                print("categories: Bad Status Code")
            case .badURL:
                print("categories: Bad URL")
            case .invalidJSONResponse:
                print("categories: Invalid JSON Response")
            case .noDataReceived:
                print("categories: No Data Received")
            case .notAnImage:
                print("categories: No Image Found")
            default:
                print("categories: Other error")
            }
        }
        CategoryAPIClient.manager.getCategories(from: urlStr, completionHandler: completion, errorHandler: errorHanlder)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaultHelper.manager.setCategory(to: row)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
}
