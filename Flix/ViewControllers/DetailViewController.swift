//
//  DetailViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/11/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

enum MovieKeys {
    static let title = "title"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var smallPosterView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let titleLabel = UILabel()//for the title of the page
    
    var movie: [String: Any]?
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            movieTitleLabel.text = movie[MovieKeys.title] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            
            let backdropPathString = movie[MovieKeys.backdropPath] as! String
            let smallPosterPathString = movie[MovieKeys.posterPath] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            backDropImageView.af_setImage(withURL: backdropURL)
            
            let smallPosterURL = URL(string: baseURLString + smallPosterPathString)!
            smallPosterView.af_setImage(withURL: smallPosterURL)
            
            /*********Title In Nav Bar*******/
            //set some attributes for the title of this controller
            let strokeTextAttributes: [NSAttributedStringKey: Any] = [
                .strokeColor : UIColor.white,
                .foregroundColor : UIColor(cgColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)),  /*UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8)*/
                .strokeWidth : -1,
                .font : UIFont.boldSystemFont(ofSize: 25)
            ]
            
            //NSMutableAttributedString(string: "0", attributes: strokeTextAttributes)
            //set the name and put in the attributes for it
            let titleText = NSAttributedString(string: "Movie Detail", attributes: strokeTextAttributes)
            
            //adding the titleText
            titleLabel.attributedText = titleText
            titleLabel.sizeToFit()
            navigationItem.titleView = titleLabel
        }
        
         scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: overviewLabel.bottomAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
