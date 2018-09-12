//
//  PosterViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/11/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieTitle.text = movie[myIndex]["title"] as? String
        overview.text = movie[myIndex]["overview"] as? String
        
        let posterPathString = movie[myIndex]["poster_path"] as! String
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
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: overview.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**********************
     * IBACTION FUNCTIONS *
     *********************/
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
