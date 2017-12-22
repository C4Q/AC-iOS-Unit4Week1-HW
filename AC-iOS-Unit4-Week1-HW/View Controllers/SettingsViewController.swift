//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var startingCategoryLabel: UILabel!
    
    @IBOutlet weak var settingsPickerView: UIPickerView!
    

    var categories = [Category]() {
        didSet {
            /// load initialized by func loadCategories
            print("=============== categories SET ===============")
            DispatchQueue.main.async {
                self.settingsPickerView.reloadAllComponents()
                if let settingsCategory = defaults.value(forKey: "selectedCategoryIndexKey") as? Int { self.settingsPickerView.selectRow(settingsCategory, inComponent: 0, animated: false)
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsPickerView.dataSource = self
        self.settingsPickerView.delegate = self
        loadCategories()
    }

    
    func loadCategories() { /// calls NYTAPIClient-Categories, uses NetworkHelper to access data
        // set completion
        let completion: ([Category]) -> Void = {(onlineCategory: [Category]) in
            self.categories = onlineCategory
        }
        // set errorHandler
        let errorHandler: (Error) -> Void = {(error: Error) in
            /// TODO: AppError handling
        }
        // API Call
        CategoryAPIClient.shared.getCategories(completionHandler: completion, errorHandler: errorHandler)
    }


}

/// PICKER VIEW DELEGATES

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
    
    
    /// load CollectionView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = categories[row]
        let categoryIndex = row
        defaults.set(categoryIndex, forKey: "selectedCategoryIndexKey")
        print("setting category set")
    }
}



