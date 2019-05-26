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
    
    // Spacing for the collection view
    let spacing = UIScreen.main.bounds.size.width * 0.001
    
    // Refresh control
    lazy var refreshControl = UIRefreshControl()
    
    var favBooks = [DataPersistenceHelper.FavoritedBook]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self; collectionView.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading favorites.")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load favorite books when view appears
        loadFavs()
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        // TODO: - Implement horizontal refresh control if possible
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FavoriteBookDetailViewController {
            if let cell = sender as? FavoritesCollectionViewCell {
                let book = favBooks[(collectionView.indexPath(for: cell)?.row)!]
                destination.book = book
            }
        }
    }

}

extension FavoritesViewController {
    
    // Function that loads favorites and sets favorites to variable in view controller
    func loadFavs() {
        DataPersistenceHelper.manager.loadFavorites()
        self.favBooks = DataPersistenceHelper.manager.getFavorites()
    }
    
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath)
        let book = favBooks[indexPath.row]
        if let cell = cell as? FavoritesCollectionViewCell {
            cell.bookImageView.image = nil
 
            // Gets the image from doc dir and sets it
            let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let cleanedPath = book.title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)! + book.isbn.description
            let imagePath = docDir!.appendingPathComponent(cleanedPath).path
            cell.bookImageView.image = UIImage(contentsOfFile: imagePath) ?? #imageLiteral(resourceName: "no-image")
            cell.setNeedsLayout()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Define amount of cells I want per row
        let numCells: CGFloat = 2
        // Calculate the number of spaces I need to account for
        let numSpaces: CGFloat = numCells + 1
        // Return a CGSize to allow for a 4 by 4 view of cells
        return CGSize(width: ((collectionView.bounds.width - (spacing * numSpaces))/numCells), height: ((collectionView.bounds.height - (spacing * numSpaces))/numCells))
    }
    
    // Set spacings to defined spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

}

