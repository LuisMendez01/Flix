//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Silvia L Mendez on 9/10/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                let movies = dataDictionary!["results"] as! [[String: Any]]
                for movie in movies {
                    let title = movie["title"] as! String
                    print(title)
                }
            }
        }
        task.resume()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
