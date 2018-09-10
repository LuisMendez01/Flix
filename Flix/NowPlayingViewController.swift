//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/10/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!//! means better not be null or else crashes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = 200
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        self.activityIndicator.startAnimating()//start the indicator before reloading data
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.fetchNowPlayingMovies()//get now playing movies from the APIs
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNowPlayingMovies() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
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
                self.movies = dataDictionary!["results"] as! [[String: Any]]//as! coz we have a key we def a have a value
                for movie in self.movies {
                    let title = movie["title"] as! String
                    print(title)
                }
                
                self.tableView.reloadData()//reload table after all movies are input in movies array
                self.refreshControl.endRefreshing()//stop refresh when data has been acquired
                self.activityIndicator.stopAnimating()//stop indicator coz data is acquired
            }
        }
        task.resume()

    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        self.activityIndicator.startAnimating()//start the indicator before reloading data
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.fetchNowPlayingMovies()//get now playing movies from the APIs
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
        
        cell.titleLabel.text = movies[indexPath.row]["title"] as? String
        cell.overviewLabel.text = movies[indexPath.row]["overview"] as? String
        
        let posterPathString = movies[indexPath.row]["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        return cell
    }

}
