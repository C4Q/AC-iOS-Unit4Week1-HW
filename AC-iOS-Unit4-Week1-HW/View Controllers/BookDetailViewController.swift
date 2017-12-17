//
//  BookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookTextView: UITextView!
    
    // MARK: - variables
    
    
    // MARK: - viewDidLoad overrides
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - functions
    @IBOutlet weak var favoriteButtonPressed: UIButton!
    
}
