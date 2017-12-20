//
//  BestSellerViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerViewController: UIViewController {
    
    var categories = [Categories]() {
        didSet {
            dump(categories)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NYTCategoriesAPIClient.manager.getCategories(completionHandler: {self.categories = $0}, errorHandler: {print($0)})
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dvc = BookDetailsViewController
        
        dvc.state = transitionState.delete 
        
    }
    
}
