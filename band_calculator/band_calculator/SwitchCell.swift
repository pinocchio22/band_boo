//
//  SwitchCell.swift
//  band_calculator
//
//  Created by t2023-m0056 on 2023/08/01.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet weak var cellSwitch: UISwitch!
    @IBOutlet weak var switchImage: UIImageView!
    @IBOutlet weak var switchName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
