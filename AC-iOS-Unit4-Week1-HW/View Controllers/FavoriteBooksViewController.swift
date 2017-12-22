//
//  FavoriteBooksViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteBooksViewController: UIViewController {

    @IBOutlet weak var favoriteBooksCollectionView: UICollectionView!
   
    let cellSpacing = UIScreen.main.bounds.width * 0.05
    
    var googleBooks: [GoogleBook] = [] {
        didSet {
            favoriteBooksCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleBooks = GoogleBookData.manager.getGoogleBooks()
        favoriteBooksCollectionView.delegate = self
        favoriteBooksCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        googleBooks = GoogleBookData.manager.getGoogleBooks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? BookDetailViewController, let cell = sender as? FavoritesCollectionViewCell, let indexPath = favoriteBooksCollectionView.indexPath(for: cell) {
            
            let currentGoogleBook = googleBooks[indexPath.row]
            
            destinationVC.googleBook = currentGoogleBook
            destinationVC.image = cell.favoriteImageView.image
        }
    }
    
}

extension FavoriteBooksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 1
        let numberOfSpaces: CGFloat = numberOfCells + 1
        let width = (collectionView.bounds.width - (numberOfSpaces * cellSpacing)) / numberOfCells
        let height = (collectionView.bounds.height - (cellSpacing * 2)) / 2
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
}

extension FavoriteBooksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return googleBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoritesCollectionViewCell
        
        let currentGoogleBook = googleBooks[indexPath.row]
        
        cell.favoriteImageView.image = nil
        
        cell.configureImageForCell(withGoogleBook: currentGoogleBook) { (appError) in
            let alertController = Alert.createAlert(forError: appError)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        return cell
    }
}
