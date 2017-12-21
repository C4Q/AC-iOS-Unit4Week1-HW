//
//  BookFlixViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookFlixViewController: UIViewController {
    
    @IBOutlet weak var bookFlixTableView: UITableView!
    
    //TODO: - What's powering the app
    //TODO: - didSet with reloading of tableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: - set delegates
        //TODO: - make date checker for one API call a day
        // loadBooks()
    }
    //TODO: - func loadBooks(){}
}


extension BookFlixViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

//TODO: - set up collection view
extension BookFlixViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

//TODO: - set up collection cells
extension BookFlixViewController: UICollectionViewDelegateFlowLayout {
    
    
    
    
}

