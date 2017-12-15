//
//  CollectionCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // disable scroll because we dont want collectionview to be scrolled inside cell
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension CollectionCell: UICollectionViewDataSource {
    // implementations here ...
    //Cell for row at
    //number of row 
}

extension CollectionCell: UICollectionViewDelegateFlowLayout {
    // implementations here ...
}
