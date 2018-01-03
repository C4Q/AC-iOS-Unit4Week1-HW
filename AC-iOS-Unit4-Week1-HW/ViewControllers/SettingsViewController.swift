//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI & Delegate
    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            pickerView.dataSource = self
            pickerView.delegate = self
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let savedCategory = UserDefaultManager.shared.fetchDefault(key: "SavedCategory"),
            let index = CategoryAPIClient.manager.listAllCategories().index(where: {$0.displayName == savedCategory.displayName}) {
                pickerView.selectRow(index, inComponent: 0, animated: true)
        }
        
        if CategoryAPIClient.manager.listAllCategories().isEmpty {
            CategoryAPIClient.manager.getCategories(from: CategoryAPIClient.manager.endpointForCategoryList,
                                                    completionHandler: { CategoryAPIClient.manager.setCategories($0.results.sorted{$0.listName < $1.listName}); self.pickerView.reloadAllComponents()},
                                                    errorHandler: {print($0)})
        }
    }
    
}

// MARK: - PICKERVIEW
extension SettingsViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CategoryAPIClient.manager.listAllCategories().count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = CategoryAPIClient.manager.listAllCategories()[row]
        return category.listName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = CategoryAPIClient.manager.listAllCategories()[row]
        let alertVC = UIAlertController(title: "Favoriting " + selectedCategory.listName , message: "Are you sure?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            UserDefaultManager.shared.setDefault(value: selectedCategory, key: "SavedCategory")
        }))
        alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}


