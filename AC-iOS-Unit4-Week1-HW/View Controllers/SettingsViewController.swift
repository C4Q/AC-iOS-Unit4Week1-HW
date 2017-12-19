//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

enum UserDefaultsKeys: String {
    case categoryIndex
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsPickerView: UIPickerView!
    
    var bookCategories = [BookCategory]() {
        didSet {
            settingsPickerView.reloadAllComponents()
            if let index = UserDefaults.standard.value(forKey: UserDefaultsKeys.categoryIndex.rawValue) as? Int {
                settingsPickerView.selectRow(index, inComponent: 0, animated: true)
            } else {
                UserDefaults.standard.set(0, forKey: UserDefaultsKeys.categoryIndex.rawValue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsPickerView.delegate = self
        self.settingsPickerView.dataSource = self
        BookCategoryAPIClient.manager.getBookCategories(completionHandler: { self.bookCategories = $0 }, errorHandler: { print($0) })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //guard bookCategories.count != 0 else { return }
        if let index = UserDefaults.standard.value(forKey: UserDefaultsKeys.categoryIndex.rawValue) as? Int {
            settingsPickerView.selectRow(index, inComponent: 0, animated: true)
        } else {
            UserDefaults.standard.set(0, forKey: UserDefaultsKeys.categoryIndex.rawValue)
        }
    }

}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bookCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bookCategories[row].display_name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(row, forKey: UserDefaultsKeys.categoryIndex.rawValue)
    }
    
}
