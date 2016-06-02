//
//  AnimatedMovieController.swift
//  Animated Movies Make Me Cry
//
//  Created by Gustavo F Oliveira on 6/1/16.
//  Copyright © 2016 Gustavo F Oliveira. All rights reserved.
//

import UIKit
import Firebase

struct Movie {
    
    var name: String!
    var thumbnail: UIImage!
    var video: String!
    var like: Int!

    init(name: String, thumbnail: UIImage, video: String, like: Int) {
        self.name = name
        self.thumbnail = thumbnail
        self.video = video
        self.like = like
    }
}

class AnimatedMovieController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var database: FIRDatabase!
    var storage: FIRStorage!
    var animatedMovies: [Movie] = [Movie]()
    
    var loading: Bool = true {
        didSet {
            self.tableView.reloadData()
            self.tableView.scrollEnabled = true
        }
    }
    
    // MARK: - Lifecycle app
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Initialize Database
        self.database = FIRDatabase.database()
        self.storage = FIRStorage.storage()
        
        self.prepareValuesForUse()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.loading {
            return 3
        } else {
            return animatedMovies.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.loading {
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath) as! LoadingAnimatedMovieCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! AnimatedMovieCell
            
            let movie = self.animatedMovies[indexPath.row]
            
            cell.thumbnailImage.image = movie.thumbnail
            cell.movieName.text = movie.name
            
            return cell
        }
        

    }
    
    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.loading {
            return CGFloat(200.0)
        } else {
            return CGFloat(270.0)
        }
    }
    
    // MARK: - Animated Movie Controller methods
    func prepareValuesForUse() {
        
        //Listen for when child nodes get added to the collection
        let moviesRef = database.reference().child("movies")
        var downloadThumbStack: Int = 0
        moviesRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            let postDict = snapshot.value as! [String: AnyObject]
            self.animatedMovies = [Movie]()
            for (_, value) in postDict.enumerate() {
                let name  = value.1["name"] as! String
                let thumb = value.1["thumbnail"] as! String
                let video = value.1["video"] as! String
                let likes = value.1["likes"] as! Int
                
                let gsReference = self.storage.referenceForURL(thumb)
                
                let downloadTask =  gsReference.dataWithMaxSize(25 * 1024 * 1024) { (data, error) -> Void in
                    if (error != nil) {
                        print("Uh-oh, an error occurred!\(error)")
                    } else {
                        let image: UIImage! = UIImage(data: data!)
                        
                        let movie = Movie(name: name, thumbnail: image, video: video, like: likes)
                        self.animatedMovies.append(movie)
                        
                        if downloadThumbStack == 0 {
                            self.loading = false
                        }
                    }
                }
                
                // Observe changes in status
                downloadTask.observeStatus(.Resume) { (snapshot) -> Void in
                    downloadThumbStack += 1
                }
                
                downloadTask.observeStatus(.Success) { (snapshot) -> Void in
                    downloadThumbStack -= 1
                }
                
                downloadTask.observeStatus(.Failure) { (snapshot) -> Void in
                    downloadThumbStack -= 1
                }
                
            }
        })
    }

}
