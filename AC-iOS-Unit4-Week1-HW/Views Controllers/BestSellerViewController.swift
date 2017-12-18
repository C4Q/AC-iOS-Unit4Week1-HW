//
//  BestSellerViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerViewController: UIViewController {
    //let defaults = UserDefaults.standard
    var categoriesArray = [Category]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ADD OUTLETS AND DELEGATES
        //ADD PickerView Default Category Here

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
