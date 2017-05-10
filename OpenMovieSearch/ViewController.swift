//
//  ViewController.swift
//  OpenMovieSearch
//
//  Created by Junaid Khan on 09/05/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleSerarch: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleSerarch.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchForMovie(title: titleSerarch.text!)
        titleSerarch.text = ""
    }
    func searchForMovie(title : String)
    {
        if let movie = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        {
            let url = URL(string: "http://www.omdbapi.com/?t=\(movie)")
            let session = URLSession.shared
            let task = session.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if  error != nil
                {
                    print("what is this: \(error)")
                }
                else
                {
                    if data != nil
                    {
                        do
                        {
                            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,AnyObject>
                            DispatchQueue.main.async {
                                print(jsonResult)
                                if let tempTitle = jsonResult["Title"] as? String
                                {
                                    self.movieTitle.text = "Title: \(tempTitle)"
                                }
                                if let tempDirector = jsonResult["Director"] as? String
                                {
                                    self.director.text = "Director: \(tempDirector)"
                                }
                                if let tempRating = jsonResult["imdbRating"] as? String{
                                    self.rating.text = "IMB Rating: \(tempRating)"
                                }
                                if let tempActor = jsonResult["Actors"] as? String
                                {
                                    self.actors.text = "Actors: \(tempActor)"
                                }
                                if let imageExsit = jsonResult["Poster"] as? String
                                {
                                    let imageurl = URL(string: imageExsit)
                                    if let imageContent = try? Data(contentsOf: imageurl!)
                                    {
                                        self.movieImage.image = UIImage(data: imageContent)
                                        self.movieImage.layer.cornerRadius = 10
                                    }
                                }
                            }
                        }
                        catch
                        {
                            print("Here it is ")
                        }
                    }
                }
            })
            task.resume()
        }
    }
}
