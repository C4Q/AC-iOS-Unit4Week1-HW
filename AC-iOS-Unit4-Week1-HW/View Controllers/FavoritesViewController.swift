//
//  FavoritesViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesCollectionView.dataSource = self
        self.favoritesCollectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoritesCollectionView.reloadData()
    }
    
    func loadFavorites() {
        FavoriteBookStore.manager.getFavorites()
    }
    

}
/// Favorites Collection View
extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoriteBookStore.manager.getFavorites().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Favorite Cell", for: indexPath) as! FavoriteCollectionViewCell
        let favorite = FavoriteBookStore.manager.getFavorites()[indexPath.row]
        configureBook(favorite: favorite, forCell: cell)
        return cell
        
    }
    
    //// call the book image
    func configureBook(favorite: BestSellerBook, forCell cell: FavoriteCollectionViewCell) {
        
        // import isbn from the book
        guard let isbn = favorite.isbns[0].isbn13 else {
            return
        }
        
        BookDetailGoogleAPIClient.shared.getBookDetails(isbn: isbn, completionHandler: {
            guard let details = $0 else {return} // populates the individual book details
            guard let imageURL = details[0].volumeInfo.imageLinks?.thumbnail else {return}
            
            cell.myFavoriteBook = details[0]
            
            ImageAPIClient.manager.loadImage(from: imageURL, completionHandler: {
                cell.favoriteImageView.image = $0
                cell.setNeedsLayout()
                
            }, errorHandler: {print("loading images from google error: \($0)")})
            
        }, errorHandler: {print("loading images from google error: \($0)")})
    }
}


/// FORMAT BEST SELLERS COLLECTION VIEW CELLS



extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    /// size of the item in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numOfCells: CGFloat = 2
        let numOfSpaces: CGFloat = numOfCells + 1 // spaces between the cells left and right
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (spacingBetweenCells * numOfSpaces)) / numOfCells, height: screenHeight * 0.4) // this Double changes the height of the cells
    }
    
    /// insets for collection view - borders at the ENDS of the entire collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacingBetweenCells, left: spacingBetweenCells, bottom: spacingBetweenCells, right: spacingBetweenCells)
    }
    
    /// spacing between rows ^v
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
    
    /// spacing between columns <>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
    
}
