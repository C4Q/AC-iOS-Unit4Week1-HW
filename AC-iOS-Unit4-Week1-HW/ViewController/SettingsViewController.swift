//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

let selectedSettingKey = "SelectedSetting"

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var categories = [AllCategories]() {
        didSet {
            DispatchQueue.main.async {
               self.settingsPickerView.reloadComponent(0)
            }
        }
    }
    
    var selectedCategoryKey = "selectedCategory"
    
    @IBOutlet weak var settingsPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsPickerView.delegate = self
        self.settingsPickerView.dataSource = self
        loadData()
        
 
    }
    
    func loadData() {
        guard let url = URL(string:"https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=44b75ac0d27a44b5a98c2919a81ffa76") else {return}
        let completion = {(onlineCategories: [AllCategories]) in
            self.categories = onlineCategories
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        SettingsAPIClient.manager.getCategories(from: url, completionHandler: completion, errorHandler: {print($0)})
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(categories.count)
        return categories.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].categoryName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        UserDefaults.standard.set(categories[row], forKey: selectedSettingKey)
    }
    
}


//    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, forComponent component: Int) {




