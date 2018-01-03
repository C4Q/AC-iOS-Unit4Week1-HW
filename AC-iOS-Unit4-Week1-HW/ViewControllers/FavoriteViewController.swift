//
//  FavoriteViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    var favoriteBooks = [Book]()
    
    // MARK: - UI & Delegate
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    // MARK: - Storyboard Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavDetailSegue" {
            let destination = segue.destination as! DetailViewController
            let selectedCell = sender as! FavoriteCell
            let index = collectionView.indexPath(for: selectedCell)!.item
            let book = favoriteBooks[index]
            destination.bookName = book.bookDetails.first?.title.capitalized ?? "No title"
            destination.bookSummary = book.isbnSummary ?? "No summaary here"
            destination.bookImage = selectedCell.imageView.image
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KeyedArchiverModel.shared.loadFavorites()
        favoriteBooks = KeyedArchiverModel.shared.getFavBooks()
        collectionView.reloadData()
    }
    
}

// MARK: - COLLECTIONVIEW
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
        if let imageFromDisk = FavoriteModel.manager.imageFromDisk(book: book) {
            cell.imageView.image = imageFromDisk
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "placeholderImage")//Placeholder image
        }
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2.1, height: collectionView.bounds.height / 2.1)
    }
}

