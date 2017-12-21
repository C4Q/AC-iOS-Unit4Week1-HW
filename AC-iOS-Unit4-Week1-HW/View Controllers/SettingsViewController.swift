//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var categoriesTableView: UITableView!

    @IBOutlet weak var showMeOnlyLabel: UILabel!
    
    @IBOutlet weak var resetCategoriesBtn: UIButton!
    
    @IBOutlet weak var saveCategoriesBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
  
}


