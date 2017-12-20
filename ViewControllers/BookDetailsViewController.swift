//
//  BookDetailsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    enum transitionState {
        case delete
        
        case favorite
    }
    
    var state = transitionState.favorite

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didClickButton() -> Void {
        // check state
        // if state is delete
        // call delete
        //if state is fav
        // call favorite
    
    }

    func delete(<#parameters#>) -> <#return type#> {
        <#function body#>
    }
    
    func favorite(<#parameters#>) -> <#return type#> {
        <#function body#>
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
