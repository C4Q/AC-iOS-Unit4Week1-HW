//
//  FavoriteViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    var favoriteBooks = [ISBNBook]()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KeyedArchiverClient.shared.loadFavorites()
        favoriteBooks = KeyedArchiverClient.shared.getFavBooks()
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension FavoriteViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if favoriteBooks.isEmpty {
            collectionView.backgroundView = {
                let label = UILabel()
                label.text = "You have no favorites!"
                label.center = collectionView.center
                label.textAlignment = .center
                return label
            }()
            return 0
        } else {
            collectionView.backgroundView = nil
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let index = indexPath.item
        let book = favoriteBooks[index]
        
        if let thumbnailUrl = book.items?.first?.volumeInfo.imageLinks.thumbnail {
            ImageDownloader.manager.getImage(from: thumbnailUrl,
                                             completionHandler: {cell.imageView.image = UIImage(data: $0); cell.setNeedsLayout()},
                                             errorHandler: {print($0)})
        } else {
            // TODO: - Set default image
        }
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2.1, height: collectionView.bounds.height / 2.1)
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        <#code#>
    //    }
}
