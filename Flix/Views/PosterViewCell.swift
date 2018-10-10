//
//  PosterViewCell.swift
//  Flix
//
//  Created by Luis Mendez on 9/15/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class PosterViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            if movie.lowResPosterURL != nil {
                
                posterImageView.af_setImage(
                    withURL: movie.lowResPosterURL!,
                    completion: { (nothing) in
                        //print("small")
                        self.posterImageView.af_setImage(
                            withURL: self.movie.highResPosterURL!,
                            completion: { (response) in
                                //print("Large")
                            }
                        )
                    }
                )
            }//if
        }//didSet
    }//Movie
}


