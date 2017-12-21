//
//  FavoriteBooksViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteBooksViewController: UIViewController {
    
    let cellSpacing: CGFloat = 5.0

    @IBOutlet weak var favoriteBooksCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteBooksCollectionView.delegate = self
        favoriteBooksCollectionView.dataSource = self
        DataPersistenceModel.shared.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteBooksCollectionView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavoriteDetails" {
            let favBookDetailsVC = segue.destination as! FavoriteBookDetailViewController
            let favBookCell = sender as! FavoriteBookCollectionViewCell
            if let indexPath = favoriteBooksCollectionView.indexPath(for: favBookCell) {
                favBookDetailsVC.favBook = DataPersistenceModel.shared.getFavoriteBooksList()[indexPath.row]
                favBookDetailsVC.favBookCoverImage = favBookCell.favoriteBookImageView.image
            }
        }
    }

}

extension FavoriteBooksViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataPersistenceModel.shared.getFavoriteBooksList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favBookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Favorite Book", for: indexPath)
        let selectedFavBook = DataPersistenceModel.shared.getFavoriteBooksList()[indexPath.row]
        if let favBookCell = favBookCell as? FavoriteBookCollectionViewCell {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            if let directoryPath = paths.first {
                let imagePath = directoryPath.appendingPathComponent(selectedFavBook.isbn)
                let bookImage = UIImage(contentsOfFile: imagePath.path)
                favBookCell.favoriteBookImageView.image = bookImage
            }
        }
        return favBookCell
    }
    
}

extension FavoriteBooksViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
}
