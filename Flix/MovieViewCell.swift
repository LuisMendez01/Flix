//
//  MovieViewCell.swift
//  Flix
//
//  Created by Luis Mendez on 9/10/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class MovieViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
