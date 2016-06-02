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
    var thumb: String!
    var video: String!
    var like: Int!

    init(name: String, thumb: String, video: String, like: Int) {
        self.name = name
        self.thumb = thumb
        self.video = video
        self.like = like
    }
}

class AnimatedMovieController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var database: FIRDatabase!
    var animatedMovies: [Movie] = [Movie]()
    
    var loading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Initialize Database
        self.database = FIRDatabase.database()
        
        //Listen for when child nodes get added to the collection
        let moviesRef = database.reference().child("movies")
        moviesRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            let postDict = snapshot.value as! [String: AnyObject]
            self.animatedMovies = [Movie]()
            for (_, value) in postDict.enumerate() {
                let name = value.1["name"] as! String
                let thumb = value.1["thumb"] as! String
                let video = value.1["video"] as! String
                let likes = value.1["likes"] as! Int
                
                let movie = Movie(name: name, thumb: thumb, video: video, like: likes)
                self.animatedMovies.append(movie)
            }
            self.loading = false
            self.tableView.reloadData()
        })
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
            
            cell.movieName.text = movie.name
            
            return cell
        }
        

    }
    
    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(200.0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
