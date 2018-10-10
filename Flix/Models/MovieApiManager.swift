//
//  MovieApiManager.swift
//  Flix
//
//  Created by Luis Mendez on 10/9/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import Foundation

class MovieApiManager {
    
    //static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func getMovies(urlString: String,completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: urlString + "now_playing?api_key=\(MovieApiManager.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                
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
                
                let movieDictionaries = dataDictionary!["results"] as! [[String: Any]]
                
                let movies = Movie.movies(dictionaries: movieDictionaries)
                
                for movie in movies {
                    print("title: \(movie.title)")
                }
                
                completion(movies, nil)//all good, send this to where this func was called
            }//else if
        }
        task.resume()
    }
    
    //Dont really need this as I can use the one above and just input url path string to it to get popular movies, like so we will have more code.
    func popularMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.popularMoviesURL + "now_playing?api_key=\(MovieApiManager.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                
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
                
                let movieDictionaries = dataDictionary!["results"] as! [[String: Any]]
                
                let movies = Movie.movies(dictionaries: movieDictionaries)
                
                for movie in movies {
                    print("title: \(movie.title)")
                }
                
                completion(movies, nil)//all good, send this to where this func was called
            }//else if
        }
        task.resume()
    }
}
