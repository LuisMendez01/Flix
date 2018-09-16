//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/10/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import AlamofireImage

var globalMovies: [[String: Any]] = []//to be used in SuperheroViewController

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [[String: Any]] = []//contains all or filter movies with searchBar
    var searchedMovies = [[String: Any]]()//contains all movies from API call
    var refreshControl: UIRefreshControl!//! means better not be null or else crashes
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self//for didSelectRowAt func tableView to work
        
        searchBar.delegate = self
        
        tableView.rowHeight = 200
        
        //first responder
        searchBar.becomeFirstResponder()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)//0 means it will show on the top
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        globalMovies = movies
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    func fetchNowPlayingMovies() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        //session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
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
                
                self.searchedMovies = self.movies
                
                self.tableView.reloadData()//reload table after all movies are input in movies array
                self.refreshControl.endRefreshing()//stop refresh when data has been acquired
                self.activityIndicator.stopAnimating()//stop indicator coz data is acquired
            }
        }
        task.resume()

    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.fetchNowPlayingMovies()//get now playing movies from the APIs
        }
    }
    
    func offLineAlert() {
        
         let alertController = UIAlertController(title: "Can't Fetch Movies", message: "Internet connection appears to be offline", preferredStyle: .alert)
         
         // create an TryAgainAction action
         let TryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
            // handle response here.
            alertController.dismiss(animated: true, completion: nil)
            self.activityIndicator.startAnimating()//start the indicator before reloading data
            self.fetchNowPlayingMovies()//get now playing movies from the APIs
         }
         // add the Try Again action to the alert controller
         alertController.addAction(TryAgainAction)
         
         self.present(alertController, animated: true, completion: nil)
        /*
         self.present(alertController, animated: true) {
         // optional code for what happens after the alert controller has finished presenting
         }
         */
    }
    
    /***********************
     * TableView functions *
     ***********************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
        
        // No color when the user selects cell
        //cell.selectionStyle = .none
        
        // Use a Dark blue color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.4699950814, green: 0.6678406, blue: 0.8381099105, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        

        //this code changes color of all cells
        cell.contentView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.7490196078, alpha: 1)
        
        cell.titleLabel.text = movies[indexPath.row]["title"] as? String
        cell.overviewLabel.text = movies[indexPath.row]["overview"] as? String
        
        let posterPathString = movies[indexPath.row]["poster_path"] as! String
        
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURLString + posterPathString)!
        let placeholderImage = UIImage(named: "poster-placeholder")
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: cell.posterImageView.frame.size,
            radius: 5.0
        )
        
        cell.posterImageView.af_setImage(
            withURL: posterURL,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(1),
            runImageTransitionIfCached: false,
            completion: (nil)
        )
        
        return cell
    }
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // If we haven't typed anything into the search bar then do not filter the results
        // movies = searchedMovies otherwise/else filter searchedMovies
        movies = searchText.isEmpty ? searchedMovies : searchedMovies.filter { ($0["title"] as! String).lowercased().contains(searchBar.text!.lowercased()) }//letter anywhere
            
            //movies = searchedMovies.filter { $0 == searchBar.text} //by whole words but who would do that lol
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the index path from the cell that was tapped
        let indexPath = tableView.indexPathForSelectedRow
        // Get the Row of the Index Path and set as index
        let index = indexPath?.row
        // Get in touch with the DetailViewController
        let detailViewController = segue.destination as! DetailViewController
        // Pass on the data to the Detail ViewController by setting it's indexPathRow value
        detailViewController.movie = movies[index!]
    }
 
}
