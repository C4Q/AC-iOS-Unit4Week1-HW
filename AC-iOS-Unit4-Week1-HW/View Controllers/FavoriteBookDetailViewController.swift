//
//  FavoriteBookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteBookDetailViewController: UIViewController {
    
    @IBOutlet weak var favBookTitleLabel: UILabel!
    @IBOutlet weak var favBookSubtitleLabel: UILabel!
    @IBOutlet weak var favBookCoverImageView: UIImageView!
    @IBOutlet weak var favBookAuthorLabel: UILabel!
    @IBOutlet weak var favBookDescriptionTextView: UITextView!
    
    var favBook: FavoriteBook?
    var favBookCoverImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let favBook = favBook else { return }
        favBookTitleLabel.text = favBook.title
        guard let favBookCoverImage = favBookCoverImage else { return }
        favBookCoverImageView.image = favBookCoverImage
        if let subtitle = favBook.subtitle { favBookSubtitleLabel.text = subtitle }
        else { favBookSubtitleLabel.text = "" }
        if let author = favBook.author { favBookAuthorLabel.text = "By \(author)" }
        else { favBookSubtitleLabel.text = "Author N/A" }
        favBookDescriptionTextView.text = favBook.longDescription
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.favBookDescriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    }

}
