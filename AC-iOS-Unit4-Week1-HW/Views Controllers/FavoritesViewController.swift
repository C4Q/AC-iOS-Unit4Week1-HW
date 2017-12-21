//
//  FavoritesViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //constant for our cell spacing which will be consistent around  our cells
    let cellSpacing: CGFloat = 20.0
    
    var favoriteBooksArray = [[BookWrapper]]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        loadData()
        
    }
    func loadData() {
        //Load the array of favoriteBooks
        FavoritesArchiverClient.manager.loadFavorites()
        favoriteBooksArray = FavoritesArchiverClient.manager.getFavorites()
        print(favoriteBooksArray)
        
    }
}
//MARK: Collection View Delegate and DataSource
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteBooksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesCells", for: indexPath) as? FavoriteCollectionViewCell else {return UICollectionViewCell() }
        
        let aFavorite = favoriteBooksArray[indexPath.row]
        cell.bookImageView.image = nil //To stop flickering
        cell.titleLabel.text = aFavorite[0].title
        cell.subtitleLabel.text = "Weeks On: \(aFavorite[0].subtitle ?? "")"
        
        //IMAGE API HERE UNTIL I ADD LOADING IMAGES FROM PHONE
        cell.spinner.isHidden = false
        cell.spinner.startAnimating()
        let setImageToOnlineImage: (UIImage) -> Void = {(onlineImage: UIImage) in
            cell.bookImageView.image = onlineImage
            cell.spinner.stopAnimating()
            cell.spinner.isHidden = true
            cell.bookImageView.setNeedsLayout()
        }
        
        ImageAPIClient.manager.getImage(from: aFavorite[0].imageLinks.thumbnail, completionHandler: setImageToOnlineImage, errorHandler: {print($0)})
        
        
        return cell
    }
    
    //FLOW LAYOUT DELEGATES
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2.0 // cells visible in row
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width // screen width of the device
        let screenHeight = UIScreen.main.bounds.height // screen height of the device
        
        //return item size
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: (screenHeight / 2) - (cellSpacing * 2))
    }
    
    //Padding around collection cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    
}






