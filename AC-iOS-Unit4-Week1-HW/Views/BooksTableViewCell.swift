//
//  BooksTableViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    
    
    //check storyBoard layout with cells and custom cells
    //TODO: - set category Label
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    func setCollectionViewDataSourceAndDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (dataSourceDelegate: D, forRow row: Int){
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}


