//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var catPickerView: UIPickerView!
    
    let url = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key="
    var catBooks = [Book]() {
        didSet {
            self.catPickerView.reloadAllComponents()
            if let index = BooksAPIClient.manager.getSetting() {
                self.catPickerView.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.catPickerView.dataSource = self
        self.catPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCategories()
    }

    func loadCategories() {
        let loadData: ([Book]) -> Void = {(onlineBook: [Book]) in
                self.catBooks = onlineBook
        }
        BooksAPIClient.manager.getBooks(from: url,completionHandler: loadData, errorHandler: {print($0)})
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return catBooks[row].listName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        BooksAPIClient.manager.saveSetting(row)
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return catBooks.count
    }
    
    
}
