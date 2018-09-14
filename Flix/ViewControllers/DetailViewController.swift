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
        }
        
        /*
         let smallImageURLString = "https://image.tmdb.org/t/p/w45"
         let largeImageURLString = "https://image.tmdb.org/t/p/original"
         
         let smallPosterURL = URL(string: smallImageURLString + posterPathString)!
         let largePosterURL = URL(string: largeImageURLString + posterPathString)!
        
         //caches and loads images
         poster.af_setImage(
         withURL: smallPosterURL,
         completion: { (nothing) in
         print("small")
         self.poster.af_setImage(
         withURL: largePosterURL,
         completion: { (nothing) in
         print("Large")
         }
         )})
         */
         scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: overviewLabel.bottomAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
     /**********************
     * IBACTION FUNCTIONS *
     *********************/
 
     /*
     let imageCache = AutoPurgingImageCache(
     memoryCapacity: 500 * 1024 * 1024,//500 MB whole cache container
     preferredMemoryUsageAfterPurge: 200 * 1024 * 1024)//200MB when replacing what already there, when cache is full
     
     UIImageView.af_sharedImageDownloader = ImageDownloader(
     configuration: ImageDownloader.defaultURLSessionConfiguration(),
     downloadPrioritization: .fifo,
     maximumActiveDownloads: 10,
     imageCache:imageCache
     )
     */
 
}
