//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerViewController: UIViewController {

    @IBOutlet weak var bestSellerCollectionView: UICollectionView!
    
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    
    var categories: [String] = [] {
        didSet {
            categoriesPickerView.reloadComponent(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
//        bestSellerCollectionView.delegate = self
//        bestSellerCollectionView.dataSource = self
        categoriesPickerView.delegate = self
        categoriesPickerView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let categoryIndex = Settings.getCategory(), Settings.categoryChanged {
            categoriesPickerView.selectRow(categoryIndex, inComponent: 0, animated: true)
            categoriesPickerView.reloadComponent(0)
        }
    }
    
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

extension BestSellerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //to do
        Settings.categoryChanged = false
    }
}

extension BestSellerViewController: UIPickerViewDataSource {
    
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
