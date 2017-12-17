//
//  BookReviewViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookReviewViewController: UIViewController {
    
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var detailedBookImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favoriteIcon: UIButton!
    
    @IBOutlet weak var bookSummary: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
