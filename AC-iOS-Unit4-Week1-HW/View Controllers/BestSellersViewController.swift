//
//  BestSellersViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellersViewController: UIViewController {
    
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    
    var bookCategories = [BookCategory]() {
        didSet {
            categoriesPickerView.reloadAllComponents()
        }
    }
    
    var bestSellers = [BestSellers]() {
        didSet {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //booksCollectionView.delegate = self
        //booksCollectionView.dataSource = self
        categoriesPickerView.delegate = self
        categoriesPickerView.dataSource = self
        loadBookCategories()
    }
    
    func loadBookCategories() {
        BookCategoryAPI.manager.getBookCategories(completionHandler: { self.bookCategories = $0 }, errorHandler: { print($0) })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BestSellersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        BestSellersAPIClient.manager.getBookCategories(with: bookCategories[row].list_name, completionHandler: { self.bestSellers = $0 }, errorHandler: { print($0) })
    }
    
}

extension BestSellersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}

extension BestSellersViewController: UICollectionViewDelegateFlowLayout {
    
}

//AIzaSyAnbRfnkNiDr6ZusJ5eT2VAnseUm0dano8 google books api
