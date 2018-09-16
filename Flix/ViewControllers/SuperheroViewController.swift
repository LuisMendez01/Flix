//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Luis Mendez on 9/15/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        /*
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: 0, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.collectionViewLayout = layout
        */
        
        //layout for movie posters
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //number of cells for collections in a row
        let cellsPerLine: CGFloat = 4
        
        //spaces between cells are always 1 less than the number of cells
        let interItemSpaces = cellsPerLine - 1
        
        //minimumInteritemSpacing it's space between width of posters
        layout.minimumInteritemSpacing = 2.5
        
        //the width of each poster, whole collection width minus the product
        //of the minimum space between cells times the # of cells, divided by cells per row
        let width = (collectionView.frame.size.width - layout.minimumInteritemSpacing*interItemSpaces) / cellsPerLine
        
        //the size of each poster item is width and height 2:3 ratio
        layout.itemSize = CGSize(width: width, height: width * (3/2))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /****************************
     * CollectionView functions *
     ****************************/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterViewCell
        
        let posterPathString = globalMovies[indexPath.item]["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let url = URL(string: baseURLString + posterPathString)!
        
        cell.posterImageView.af_setImage(withURL: url)
        
        return cell
    }

}
