//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Tyler Zhao on 12/19/17.
//  Copyright © 2017 Tyler Zhao . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerData = [Categories]() {
        didSet {
            pickerView.reloadAllComponents()
            pickerView.selectRow(DataModel.selectedPickerRow, inComponent: 0, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        loadPickerData()
    }
    
    private func loadPickerData() {
        let url = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=9001fc4817314380b77393a05f655409"
        let completion = {(onlineCategories: [Categories]) in
            self.pickerData = onlineCategories
        }
        CategoriesAPIClient.manager.getCategories(from: url,
                                                  completionHandler: completion,
                                                  errorHandler: {print($0)})
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(row, forKey: "SelectedRow")
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].display_name
    }
}

