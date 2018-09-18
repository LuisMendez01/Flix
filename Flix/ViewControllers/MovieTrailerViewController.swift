//
//  MovieTrailerViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/17/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import WebKit

class MovieTrailerViewController: UIViewController, WKNavigationDelegate  {

    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var id: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        webView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.7490196078, alpha: 1)
        activityIndicator.startAnimating()
        
        fetchMovieTrailer(){ url in
            
            let request = URLRequest(url: url!, cachePolicy: .reloadRevalidatingCacheData,timeoutInterval: 15.0)
            
            self.webView.load(request)
            
        }
        
        dismissButton.layer.borderWidth = -1;
        /*
        let strokeTextAttributes: [NSAttributedStringKey: Any] = [
            .strokeColor : UIColor.white,
            .foregroundColor : UIColor(cgColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)),  /*UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8)*/
            .strokeWidth : -1,//negative #s will show u foregroundColor, positive #s won't show it
            .font : UIFont.boldSystemFont(ofSize: 25)
        ]
        
        // .Selected
        let mySelectedAttributedTitle = NSAttributedString(string: "Click Here",
            attributes: [NSAttributedStringKey.foregroundColor : UIColor.green])
        
        dismissButton.setAttributedTitle(mySelectedAttributedTitle, for: .selected)
        
        // .Normal
        let myNormalAttributedTitle = NSAttributedString(string: "Click Here",
            attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
 
        dismissButton.setAttributedTitle(myNormalAttributedTitle, for: .normal)
*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        print("loaded")
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!, withError error: Error) {
        print("WKWebView failed")
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    func fetchMovieTrailer(completion: @escaping ((_ url:URL?)->())) {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                    // Your code with delay
                    self.offLineAlert()//show alert
                    //completion(nil)
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
                
                let key = videos[0]["key"] as! String
                let url = URL(string: "https://www.youtube.com/watch?v=\(key)")
                print("got url")
                completion(url)
                
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
        
        print("below task.resume")
    }
    
    func offLineAlert() {
        
        let alertController = UIAlertController(title: "Can't Fetch Trailer", message: "Internet connection appears to be offline", preferredStyle: .alert)
        
        // create an TryAgainAction action
        let TryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
            // handle response here.
            alertController.dismiss(animated: true, completion: nil)
            //self.activityIndicator.startAnimating()//start the indicator before reloading data
            self.fetchMovieTrailer(){ url in
                
                let request = URLRequest(url: url!)
                self.webView.load(request)
            }//get now playing movies from the APIs
        }
        // add the Try Again action to the alert controller
        alertController.addAction(TryAgainAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
