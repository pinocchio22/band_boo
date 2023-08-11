//
//  UserInfoCell.swift
//  band_calculator
//
//  Created by t2023-m0056 on 2023/07/26.
//

import UIKit

class MenuCell: UITableViewCell {

    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
