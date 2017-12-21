//
//  FavoriteViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    var favoriteObjects = [Favorite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoriteCollectionView.delegate = self
        self.favoriteCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //favoriteObjects = getFavorite
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       favoriteCollectionView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FavoriteDetailViewController {
//            let selectedBook = favoriteCollectionView.indexPathsForSelectedItems
            let cell = sender as! FavoriteCollectionViewCell
            guard favoriteCollectionView.indexPath(for: cell) != nil else {return}
            destination.book = cell.savedBooks
        }
    }
    
}
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BookDataStore.manager.getFavorites().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCollectionViewCell
        let favorite = BookDataStore.manager.getFavorites()[indexPath.row]
        guard let image = BookDataStore.manager.getImage(identifier: favorite.identifier) else {
            cell.favoritePhoto.image = #imageLiteral(resourceName: "Image")
            return cell}
        cell.favoritePhoto.image = image
        
        
        return cell
    }
    
    
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
}








