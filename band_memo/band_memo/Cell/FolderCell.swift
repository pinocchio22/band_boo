//
//  FolderCell.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/01.
//

import UIKit

class FolderCell: UITableViewCell {

    @IBOutlet weak var folderCount: UILabel!
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var folderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
