//
//  DetailViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/11/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var smallPosterView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let titleLabel = UILabel()//for the title of the page
    
    var movie: Movie!
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitleLabel.text = movie.title
        
        releaseDateLabel.text = movie.release_date
        overviewLabel.text = movie.overview
        
        
        if movie.posterUrl != nil {
            smallPosterView.af_setImage(withURL: movie.posterUrl!)
        }
            
        if movie.posterUrl != nil {
            backDropImageView.af_setImage(withURL: movie.backPosterUrl!)
        }
        
        /*********Title In Nav Bar*******/
        //set some attributes for the title of this controller
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
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
    
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: overviewLabel.bottomAnchor).isActive = true
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.tapToTrailer(_:)))
        
        smallPosterView.isUserInteractionEnabled = true
        smallPosterView.addGestureRecognizer(imageTap)
        
        print("DetailController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    @objc func tapToTrailer(_ sender: UIImage) {
        print("segue to MovieTrailerController")
        performSegue(withIdentifier: "trailer", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieTrailerViewController = segue.destination as! MovieTrailerViewController
        
        movieTrailerViewController.id = (movie.id)
    }
    
  
}
