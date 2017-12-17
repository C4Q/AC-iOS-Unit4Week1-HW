//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellersViewController: UIViewController {

    @IBOutlet weak var bestSellersCollectionView: UICollectionView!
    
    @IBOutlet weak var bestSellersCategoryPickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bestSellersCollectionView.dataSource = self
        self.bestSellersCategoryPickerView.dataSource = self
    }
    
}


/// Best Sellers Collection View
extension BestSellersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

/// Picker
extension BestSellersViewController: UIPickerViewDataSource {
    
    
    
}
