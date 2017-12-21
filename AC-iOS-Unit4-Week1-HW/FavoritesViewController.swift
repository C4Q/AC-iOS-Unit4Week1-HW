//
//  FavoritesViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Tyler Zhao on 12/19/17.
//  Copyright © 2017 Tyler Zhao . All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    let cellSpacing: CGFloat = 10
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        DataModel.shared.load()
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataModel.shared.getLists().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Favorites Cell", for: indexPath) as! FavoritesCellCollectionViewCell
        let book = DataModel.shared.getLists()[indexPath.row]
        
        cell.bookTitleLabel.text = book.title
        let imageLink = book.imageUrl
            ImageAPIClient.manager.loadImage(from: imageLink,
                                             completionHandler: {cell.favoriteBookImage.image = $0},
                                             errorHandler: {print($0)})
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width
        
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: (collectionView.bounds.height / 2) - (cellSpacing * 2) )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
