//
//  MovieViewCell.swift
//  Flix
//
//  Created by Luis Mendez on 9/10/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            
            if movie.posterUrl != nil {
                let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: posterImageView.frame.size,
                    radius: 5.0
                )
                let placeholderImage = UIImage(named: "poster-placeholder")
                
                posterImageView.af_setImage(
                    withURL: movie.posterUrl!,
                    placeholderImage: placeholderImage,
                    filter: filter,
                    imageTransition: .crossDissolve(1),
                    runImageTransitionIfCached: false,
                    completion: (nil)
                )
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
