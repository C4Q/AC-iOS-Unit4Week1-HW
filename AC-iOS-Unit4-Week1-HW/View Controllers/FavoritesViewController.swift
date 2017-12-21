//
//  FavoritesViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    //MARK - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK - variables
    var favoriteBooks = [DataModel.BookFavorites]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let spacing = UIScreen.main.bounds.size.width * 0.05
    
    //MARK - ViewDidLoad overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        loadUI()
    }
    
    func loadUI() {
        favoriteBooks = DataModel.manager.loadFavoriteBooks()
    }
    
}

//MARK: - UICollectionView
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteBooks.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteBookCell", for: indexPath)
        let book = favoriteBooks[indexPath.row]
        if let cell = cell as? FavoriteBookCell {
            cell.imageView.image = nil
            cell.hideActivityIndicator(false)
            let favoritesBookDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let imagePath = favoritesBookDirectory!.appendingPathComponent(book.isbn).path
            cell.imageView.image = UIImage(contentsOfFile: imagePath) ?? #imageLiteral(resourceName: "StashNoImage")
            cell.hideActivityIndicator(true)
            cell.setNeedsLayout()
        }
        return cell
    }
}

// MARK: CollectionView
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2
        let numSpaces: CGFloat = numCells + 1
        return CGSize(width: ((collectionView.bounds.width - (spacing * numSpaces))/numCells), height: ((collectionView.bounds.height - (spacing * numSpaces))/numCells))
    }
    
    //insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    //minimumLineSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    //minimumInteritemSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
}
