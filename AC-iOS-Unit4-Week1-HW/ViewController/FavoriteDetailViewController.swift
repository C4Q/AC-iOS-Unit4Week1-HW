//
//  FavoriteDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
import Foundation

class FavoriteDetailViewController: UIViewController {
    
    @IBOutlet weak var favoriteDetailSubtitle: UILabel!
    @IBOutlet weak var favoriteDetailDescription: UITextView!
    @IBOutlet weak var favoriteDetailImage: UIImageView!
    
    var favoritebook: Favorite?
    var favoriteImage: UIImage?
    
    override func viewDidLoad() {
        favoriteDetailSubtitle.text = favoritebook?.subtitle
        favoriteDetailDescription.text = favoritebook?.description
        favoriteDetailImage.image = favoriteImage
        super.viewDidLoad()

        
    }
    


}
