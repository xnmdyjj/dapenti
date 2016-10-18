//
//  TuguaTableViewCell.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/14.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit

class TuguaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
