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
    
    let spacing = UIScreen.main.bounds.size.width * 0.001
    
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
        
        loadFavs()
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        print("please work")
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
            //print(book.bookImagePath)
            
            //cell.bookImageView.image = UIImage(contentsOfFile: DataPersistenceHelper.manager.documentsDirectory().appendingPathComponent("Manga9781626923508").path)
            
            let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let cleanedPath = book.title.replacingOccurrences(of: " ", with: "%20") + book.isbn.description
//            print(cleanedPath)
//            print("THE%20LEGEND%20OF%20ZELDA%3A%20LEGENDARY%20EDITION,%20VOL.%2029781421589602")
//            print(cleanedPath == "THE%20LEGEND%20OF%20ZELDA%3A%20LEGENDARY%20EDITION,%20VOL.%2029781421589602")
            let imagePath = docDir!.appendingPathComponent(cleanedPath).path
            
            cell.bookImageView.image = UIImage(contentsOfFile: imagePath) ?? #imageLiteral(resourceName: "no-image")
            
            cell.setNeedsLayout()
            
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2
        let numSpaces: CGFloat = numCells + 1
        return CGSize(width: ((collectionView.bounds.width - (spacing * numSpaces))/numCells), height: ((collectionView.bounds.height - (spacing * numSpaces))/numCells))
        
    }
    
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

