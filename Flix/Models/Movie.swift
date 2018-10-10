//
//  Movie.swift
//  Flix
//
//  Created by Luis Mendez on 10/9/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import Foundation

class Movie {
    
    var id: Int
    var title: String
    var overview: String
    var release_date: String
    var posterUrl: URL?
    var backPosterUrl: URL?
    var lowResPosterURL: URL?
    var highResPosterURL: URL?
    
    init(dictionary: [String: Any]) {
        
        id = (dictionary["id"] as? Int)!
        title = dictionary["title"] as? String ?? "No title"
        overview = dictionary["overview"] as? String ?? "No description"
        release_date = dictionary["release_date"] as? String ?? "No date yet"
        
        //Main poster
        if let posterPathString = dictionary["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            posterUrl = URL(string: baseURLString + posterPathString)!
        }
        
        //big back poster for DetailVC
        if let posterPathString = dictionary["backdrop_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            backPosterUrl = URL(string: baseURLString + posterPathString)!
        }
        
        /********** low and heigh resolution posters for SuperHeroVC **************/
        if let lowResposterPathString = dictionary["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w45"
            lowResPosterURL = URL(string: baseURLString + lowResposterPathString)!
        }
        
        if let highResposterPathString = dictionary["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/original"
            highResPosterURL = URL(string: baseURLString + highResposterPathString)!
        }
        
        // Set the rest of the properties
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
