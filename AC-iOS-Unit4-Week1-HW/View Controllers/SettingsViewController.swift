//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var startingCategoryLabel: UILabel!
    
    @IBOutlet weak var settingsPickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsPickerView.dataSource = self

    }



}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0 /// TODO
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0 /// TODO
    }
    
    
    
    
}
