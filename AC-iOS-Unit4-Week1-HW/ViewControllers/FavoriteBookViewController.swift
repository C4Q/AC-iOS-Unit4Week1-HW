//
//  FavoriteBookViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteBookViewController: UIViewController {

    var favorites = [DataModel.Favorite]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.dataSource = self
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        DataModel.shared.load()
        self.favorites = DataModel.shared.getLists()
    }

}
extension FavoriteBookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {return UICollectionViewCell()}
        let favorite = favorites[indexPath.row]
        cell.favoriteImageView.image = nil
        
        let favoritesBookDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagePath = favoritesBookDirectory!.appendingPathComponent(favorite.isbn).path
        cell.favoriteImageView.image = UIImage(contentsOfFile: imagePath) ?? #imageLiteral(resourceName: "not-available")
        cell.setNeedsLayout()
        
        return cell
    }
}
