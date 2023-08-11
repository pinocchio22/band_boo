//
//  MemoCell.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/03.
//

import UIKit

class MemoCell: UITableViewCell {

    @IBOutlet weak var memoFolder: UILabel!
    @IBOutlet weak var memoContent: UILabel!
    @IBOutlet weak var memoDate: UILabel!
    @IBOutlet weak var memoName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
