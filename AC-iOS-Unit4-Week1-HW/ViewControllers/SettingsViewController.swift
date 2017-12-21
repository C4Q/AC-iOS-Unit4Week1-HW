//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var bookTypes = [BookType]() {
        didSet {
            pickerView.reloadAllComponents()
            if let index = UserDefaultHelper.manager.getBook() {
                pickerView.selectRow(index, inComponent: 0, animated: true)
            } else {
                UserDefaultHelper.manager.setBook(to: 0)
            }
        }
    }
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        loadBookTypes()
    }
    func loadBookTypes() {
        BookAPIClient.manager.getBookType(completionHandler: {self.bookTypes = $0}, errorHandler: {print($0)})
    }
}
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bookTypes[row].name
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaultHelper.manager.setBook(to: row)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bookTypes.count
    }
}
