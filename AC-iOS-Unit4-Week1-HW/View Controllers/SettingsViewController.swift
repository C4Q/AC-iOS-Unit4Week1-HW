//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    
    var categories: [String] = [] {
        didSet {
            categoriesPickerView.reloadComponent(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        categoriesPickerView.dataSource = self
        categoriesPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let categoryIndex = Settings.getCategory() {
            categoriesPickerView.selectRow(categoryIndex, inComponent: 0, animated: true)
            categoriesPickerView.reloadComponent(0)
        }
    }
    
    //question: I call this function twice to load categories - what should I do to reduce redundancy?
    func loadCategories() {
        self.categories = CategoryData.manager.getCategories()
        
        if categories.isEmpty {
            CategoryAPIClient.manager.getCategories(completionHandler: { (onlineCategories) in
               
                let categories = onlineCategories.map{$0.listName}.sorted{$0 < $1}
                CategoryData.manager.addCategories(categories)
                
                self.categories = CategoryData.manager.getCategories()
                
            }, errorHandler: { (appError) in
                let errorAlert = Alert.createAlert(forError: appError)
                
                self.present(errorAlert, animated: true, completion: nil)
            })
        }
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Settings.saveCategory(atIndex: row)
        Settings.categoryChanged = true
    }
}
