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
    
    var id: Int = -1//value for this is passed from DetailVC
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self//needed to use its functions
        
        webView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.7490196078, alpha: 1) //white background is default
        
        activityIndicator.startAnimating()//indicate loading
        
        fetchMovieTrailer(){ url in
            
            let request = URLRequest(url: url!, cachePolicy: .reloadRevalidatingCacheData,timeoutInterval: 15.0)
            
            self.webView.load(request)
            
        }
        
        dismissButton.layer.borderWidth = -1;
        
        
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor : UIColor.white,
            .foregroundColor : UIColor(cgColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)),  /*UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8)*/
            .strokeWidth : -1,//negative #s will show u foregroundColor, positive #s won't show it
            .font : UIFont.boldSystemFont(ofSize: 27)
        ]
        
        let mySelectedAttributedTitle = NSAttributedString(string: "DISMISS", attributes: strokeTextAttributes)
        
        dismissButton.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
        /*
        dismissButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        dismissButton.layer.borderWidth = 0.5
        */
        dismissButton.layer.cornerRadius = 5
        dismissButton.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /***********************
     * WKWebView FUNCTIONS *
     ***********************/
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        
        print("loaded")
        self.activityIndicator.stopAnimating()//stop indicator when WKWebView has loaded
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!, withError error: Error) {
        print("WKWebView failed")
    }
    
    /**********************
     * @IBOULET FUNCTIONS *
     **********************/
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)//dismiss this controller
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
                }
                
            } else if let response = response as? HTTPURLResponse,
                response.statusCode == 200, let data = data {
                
                var dataDictionary: [String: Any]?
                do {
                    dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
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
                 //traverse all trailers in teasers
                for video in videos {
                    let key = video["key"] as! String
                    print("title: \(key)")
                }//traverse all videos
                */
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
            
            self.fetchMovieTrailer(){ url in
                
                let request = URLRequest(url: url!)
                self.webView.load(request)
            }//get Superheros movies from the APIs
        }
        // add the Try Again action to the alert controller
        alertController.addAction(TryAgainAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
