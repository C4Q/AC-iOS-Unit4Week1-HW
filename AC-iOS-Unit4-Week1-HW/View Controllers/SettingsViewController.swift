//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//



import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!

    // MARK: - variables
    var categories = [CategoryResults]() {
        didSet {
            categoryPicker.reloadAllComponents()
        }
    }
    
    var categorySelected = ""
    
    // MARK: - viewDidLoad overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        //avoided using API call by loading stored categories
        categories = PickerCategories.loadCategories()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        UserDefaultsHelper.manager.setDefaultBookCategory(to: self.categorySelected)
    }
}

// MARK: - PickerView
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // numberOfRowsInComponent
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count // number of dict in Array
    }
    
    // titleForRow
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].displayName
    }
    
    // didSelectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySelected = categories[row].displayName
    }
    
}


