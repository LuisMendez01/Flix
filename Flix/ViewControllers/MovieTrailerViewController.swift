//
//  MovieTrailerViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/17/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import WebKit

class MovieTrailerViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    
    var id: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMovieTrailer()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    func fetchMovieTrailer() {
        
        var key = ""
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                    // Your code with delay
                    //self.offLineAlert()//show alert
                }
                
            } else if let response = response as? HTTPURLResponse,
                response.statusCode == 200, let data = data {
                
                var dataDictionary: [String: Any]?
                do {
                    dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    //as? [String: Any] means it's ["result": array of dictionaries/moviesINfo]
                } catch let parseError {
                    
                    print(parseError.localizedDescription)
                    return
                }
                // Handle dataDictionary
                //print(dataDictionary as Any)
                let videos = dataDictionary!["results"] as! [[String: Any]]//as! coz we have a key we def a have a value
                
                key = videos[0]["key"] as! String
                
                let url = URL(string: "https://www.youtube.com/watch?v=\(key)")
                let request = URLRequest(url: url!)
                self.webView.load(request)
                
                /*
                for video in videos {
                    let key = video["key"] as! String
                    print("title: \(key)")
                }//traverse all videos
                */
             
                //self.refreshControl.endRefreshing()//stop refresh when data has been acquired
                //self.activityIndicator.stopAnimating()//stop indicator coz data is acquired
            }
        }
        task.resume()
    }
}
