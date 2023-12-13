//
//  MovieSearchController.swift
//  Cinemate
//
//  Created by user235924 on 12/4/23.
//

import UIKit

class MovieSearchController: UITableViewController, UISearchBarDelegate,NetworkingDelegate {
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    var movieSearchDetails: [MovieSearchDetail] = []
    var pageNumber: Int = 1
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSearchDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = movieSearchDetails[indexPath.row].title
        
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pageNumber = 1
        if (searchText.count <= 2){
            movieSearchDetails = [MovieSearchDetail]()
            tableView.reloadData()
        }
        if (searchText.count > 2){
            NetworkingManager.shared.getMovieSearchResults(searchText: searchText,pageNum: pageNumber)
        }
    }
    
    func networkingDidFinishWithMovies(movieSearchDetails: [MovieSearchDetail]) {
        DispatchQueue.main.async {
            self.movieSearchDetails = movieSearchDetails
            self.tableView.reloadData()
        }
    }
    
    func networkingDidFinishWithMovieDetails(movieDetail: MovieDetail) {
        
    }
    
    func networkingDidFinishWithError() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       var bdc = segue.destination as! BasicDisplayController

        var i = tableView.indexPathForSelectedRow
        bdc.movieDetailFromSVC = movieSearchDetails[i!.row]
    }
    
    @IBAction func getNextPage(_ sender: Any) {
        pageNumber += 1
        if let searchText = searchBar.text{
            if(searchText.count>2){
                NetworkingManager.shared.getMovieSearchResults(searchText: searchText,pageNum: pageNumber)
            }else{
                var alertController = UIAlertController(title: "Short Query", message: "Query must be atleast 3 letters long.", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                            alertController.dismiss(animated: true, completion: nil)
                        })

                present(alertController, animated: true, completion: nil)
            }
        }
        else{
            var alertController = UIAlertController(title: "Missing Data", message: "Enter movie query in search bar.", preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                    })

            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.shared.delegate = self
        pageNumber = 1
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkingManager.shared.delegate = self
        pageNumber = 1
        searchBar.text = ""
        movieSearchDetails = [MovieSearchDetail]()
        tableView.reloadData()
        
    }

}
