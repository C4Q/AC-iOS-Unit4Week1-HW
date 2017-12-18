//
//  FavoritesViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var refreshControl = UIRefreshControl()
    
    var favBooks = [DataPersistenceHelper.FavoritedBook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading favorites.")
        refreshControl.addTarget(self, action: Selector(("refresh:")), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        loadFavs()
    }
    
    func refresh(_ sender: AnyObject) {
        
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

extension FavoritesViewController {
    
    func loadFavs() {
        DataPersistenceHelper.manager.loadFavorites()
        self.favBooks = DataPersistenceHelper.manager.getFavorites()
    }
    
}

//extension FavoritesViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//
//}

