//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var categories = [BestSellerCategory]() {
        didSet {
            pickerView.reloadAllComponents()
            
            // Rotates the picker view to the saved position if available
            if let defaults = UserDefaultsHelper.manager.getValue() {
                pickerView.selectRow(defaults.pickerPosition, inComponent:0, animated:true)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self; pickerView.delegate = self
        loadCategories()
    }

}

extension SettingsViewController {
    
    func loadCategories() {
        NYTimesAPIClient.manager.getBestSellerCategories(completionHandler: { self.categories = $0 }, errorHandler: { print($0) })
    }
    
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let settings = UserDefaultsHelper.MyDefaults(pickerPosition: row, title: categories[row].displayName)
        UserDefaultsHelper.manager.createDefaultSetting(value: settings)
    }
    
}
