//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/10/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [Movie] = []//contains all or filter movies with searchBar
    var searchedMovies: [Movie] = []//contains all movies from API call
    var refreshControl: UIRefreshControl!//! means better not be null or else crashes
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self//for didSelectRowAt func tableView to work
        
        searchBar.delegate = self
        
        //tableView.rowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
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
        
        /*********Title In Nav Bar*******/
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor : UIColor.white,
            .foregroundColor : UIColor(cgColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)),  /*UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8)*/
            .strokeWidth : -1,//negative #s will show u foregroundColor, positive #s won't show it
            .font : UIFont.boldSystemFont(ofSize: 28)
        ]
        
        //self.navigationItem.title = "TitleBar"//changes the name on the title navBar, it's hardcoded now on storyBoard
        
        //add the attributes to the navbar title
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = strokeTextAttributes
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    func fetchNowPlayingMovies() {
        
        let baseUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"
        
        MovieApiManager().getMovies(urlString: baseUrl) { (movies: [Movie]?, error: Error?) in
            
            if let movies = movies {
                self.movies = movies
                self.searchedMovies = self.movies
                
                self.tableView.reloadData()//reload table after all movies are input in movies array
                self.refreshControl.endRefreshing()//stop refresh when data has been acquired
                self.activityIndicator.stopAnimating()//stop indicator coz data is acquired
                
            } else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                    // Your code with delay
                    self.offLineAlert()//show alert
                }
            }
        }

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
        backgroundView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        

        //this code changes color of all cells
        cell.contentView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.7490196078, alpha: 1)
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background of the view of the selected cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // If we haven't typed anything into the search bar then do not filter the results
        // movies = searchedMovies otherwise/else filter searchedMovies
        movies = searchText.isEmpty ? searchedMovies : searchedMovies.filter { ($0.title).lowercased().contains(searchBar.text!.lowercased()) }//letter anywhere
            
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
/* if want to add more options to navbar
 if let navigationBar = navigationController?.navigationBar {
 /*
 //navigationBar.setBackgroundImage(UIImage(named: "codepath-logo"), for: .default)
 //navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
 
 let shadow = NSShadow()
 shadow.shadowColor = UIColor.gray.withAlphaComponent(0.5)
 shadow.shadowOffset = CGSize(width: 2, height: 2)
 shadow.shadowBlurRadius = 4 */
 navigationBar.titleTextAttributes = strokeTextAttributes
 
 }
 */
