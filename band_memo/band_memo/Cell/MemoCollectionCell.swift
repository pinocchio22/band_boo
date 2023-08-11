//
//  MemoCollectionCell.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/01.
//

import UIKit

class MemoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var collectionFolder: UILabel!
    @IBOutlet weak var collectionDate: UILabel!
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
