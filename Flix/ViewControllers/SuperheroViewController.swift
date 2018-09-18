//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/15/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var superheroSearchBar: UISearchBar!
    
    let titleLabel = UILabel()//label for title
    var grid = 0;//keeps track of grid size grid X grid size
    
    var movies: [[String: Any]] = []//contains all or filter movies with searchBar
    var searchedMovies = [[String: Any]]()//contains all movies from API call
    
    var refreshControl: UIRefreshControl!//! means better not be null or else crashes
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        superheroSearchBar.delegate = self
        
        //first responder
        superheroSearchBar.becomeFirstResponder()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        
        collectionView.insertSubview(refreshControl, at: 0)//0 means it will show on the top
        
        /*********Layout for movies*******/
        changeGridLayout()
        
        /*********Title In Nav Bar*******/
        setTitleNavBar()
        
        /***************Create btn for grid**************************/
        setGridButton()
        
        /********Fetching SuperHero Posters **********/
        self.activityIndicator.startAnimating()//start the indicator before reloading data
        self.fetchSuperheroMovies()//get now playing movies from the APIs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*******************
     * @OBJC FUNCTIONS *
     *******************/
    @objc func changeGridLayout(){
        
        grid=grid+1;
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //number of cells for collections in a row
        let cellsPerLine: CGFloat = (CGFloat(grid % 4)+1)
        
        //spaces between cells are always 1 less than the number of cells
        let interItemSpaces = cellsPerLine - 1
        
        //minimumInteritemSpacing it's space between width of posters
        //layout.minimumInteritemSpacing = 2.5 It's taking it from storyboard
        //layout.minimumLineSpacing = 2.5 It's taking it from storyboard
        
        //the width of each poster, whole collection width minus the product
        //of the minimum space between cells times the # of cells, divided by cells per row
        let width = (collectionView.frame.size.width - layout.minimumInteritemSpacing*interItemSpaces) / cellsPerLine
        
        //the size of each poster item is width and height 2:3 ratio
        layout.itemSize = CGSize(width: width, height: width * (3/2))
    }
    
    //target functions for grid button
    @objc func HoldDown(_ btn:UIButton)
    {
        btn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    @objc func holdRelease(_ btn:UIButton)
    {
        btn.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.7490196078, alpha: 1)
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.fetchSuperheroMovies()//get now playing movies from the APIs
        }
    }
    
    /****************************
     * CollectionView functions *
     ****************************/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterViewCell
        
        let posterPathString = movies[indexPath.item]["poster_path"] as! String
        let smallImageURLString = "https://image.tmdb.org/t/p/w45"
        let largeImageURLString = "https://image.tmdb.org/t/p/original"
         
        let smallPosterURL = URL(string: smallImageURLString + posterPathString)!
        let largePosterURL = URL(string: largeImageURLString + posterPathString)!
         
        //caches and loads images
        cell.posterImageView.af_setImage(
            withURL: smallPosterURL,
            completion: { (nothing) in
                print("small")
                cell.posterImageView.af_setImage(
                    withURL: largePosterURL,
                    completion: { (response) in
                        print("Large")
                }
                )
            }
        )
        
        return cell
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    func setTitleNavBar(){
        
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor : UIColor.white,
            .foregroundColor : UIColor(cgColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)),  /*UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8)*/
            .strokeWidth : -1,//negative #s will show u foregroundColor, positive #s won't show it
            .font : UIFont.boldSystemFont(ofSize: 25)
        ]
        
        //self.navigationItem.title = "TitleBar"//changes the name on the title navBar, it's hardcoded now on storyBoard
        
        //add the attributes to the navbar title
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = strokeTextAttributes
        }
        
        //change the back button of this nav bar to "Movies" coz title of
        //this nav bar is "MoviePosters" and it's too long to be a back btn
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Movies", style: .plain, target: nil, action: nil)
    }
    
    func setGridButton(){
        
        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "grid.png"), for: UIControl.State.normal)
        //add function for button
        button.addTarget(self, action: #selector(SuperheroViewController.changeGridLayout), for: UIControl.Event.touchUpInside)
        
        //functions to change color when btn is held and released
        button.addTarget(self, action: #selector(SuperheroViewController.holdRelease(_:)), for: UIControl.Event.touchUpInside);
        button.addTarget(self, action: #selector(SuperheroViewController.HoldDown(_:)), for: UIControl.Event.touchDown)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func fetchSuperheroMovies() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/363088/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
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
                    let id = movie["id"] as! Int
                    print("title: \(title)")
                    print("id: \(id)")
                }
                
                self.searchedMovies = self.movies
                
                self.collectionView.reloadData()//reload table after all movies are input in movies array
                self.refreshControl.endRefreshing()//stop refresh when data has been acquired
                self.activityIndicator.stopAnimating()//stop indicator coz data is acquired
            }
        }
        task.resume()
        
    }
    
    func offLineAlert() {
        
        let alertController = UIAlertController(title: "Can't Fetch Movies", message: "Internet connection appears to be offline", preferredStyle: .alert)
        
        // create an TryAgainAction action
        let TryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
            // handle response here.
            alertController.dismiss(animated: true, completion: nil)
            self.activityIndicator.startAnimating()//start the indicator before reloading data
            self.fetchSuperheroMovies()//get now playing movies from the APIs
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // If we haven't typed anything into the search bar then do not filter the results
        // movies = searchedMovies otherwise/else filter searchedMovies
        movies = searchText.isEmpty ? searchedMovies : searchedMovies.filter { ($0["title"] as! String).lowercased().contains(searchBar.text!.lowercased()) }//letter anywhere
        
        //movies = searchedMovies.filter { $0 == searchBar.text} //by whole words but who would do that lol
        
        collectionView.reloadData()
    }
    
    //connect items to send to DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UICollectionViewCell
        // Get the index path from the cell that was tapped
        let indexPath = collectionView!.indexPath(for: cell) //tableView.indexPathForSelectedRow
        // Get the Row of the Index Path and set as index
        let index = indexPath?.row
        print("index: \(index!)")
        // Get in touch with the DetailViewController
        let detailViewController = segue.destination as! DetailViewController
        // Pass on the data to the Detail ViewController by setting it's indexPathRow value
        detailViewController.movie = movies[index!]
    }
}

//more layout options to check out
/*
 let layout = UICollectionViewFlowLayout()
 layout.itemSize = CGSize(width: 100, height: 100)
 layout.minimumInteritemSpacing = 8
 layout.minimumLineSpacing = 8
 layout.headerReferenceSize = CGSize(width: 0, height: 40)
 layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
 collectionView.collectionViewLayout = layout
 */

//more navigation bar options for buttons
/*
 //code to add two buttons to left and right sides of navbar
 let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(NameController.saveButtonTapped)
 
 //set frame, not sure if this works coz I didn't see any change
 //saveButton.frame = CGRect(x: 0, y: 0, width: 35, height: 51)
 
 let segmentedControl = UISegmentedControl(items: ["Foo", "Bar"])
 segmentedControl.sizeToFit()
 let segmentedButton = UIBarButtonItem(customView: segmentedControl)
 
 let dummyButton = UIBarButtonItem(title: "Dummy", style: .plain, target: nil, action: nil)
 
 navigationItem.rightBarButtonItems = [saveButton, segmentedButton]
 navigationItem.leftBarButtonItem = dummyButton
 */

//this sets a button called Grid to right side of navbar
//navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(SuperheroViewController.changeGridLayout))


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
