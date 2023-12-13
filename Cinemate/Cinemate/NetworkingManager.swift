//
//  NetworkManager.swift
//  Cinemate
//
//  Created by user235924 on 12/4/23.
//

import Foundation

protocol NetworkingDelegate{
    func networkingDidFinishWithMovies(movieSearchDetails : [MovieSearchDetail])
    func networkingDidFinishWithMovieDetails(movieDetail: MovieDetail)
    func networkingDidFinishWithError()
}

class NetworkingManager {
    
    static var shared = NetworkingManager()
    var delegate : NetworkingDelegate?
    var api_key = "e667990d87115631f833632f559659d0"
    
    func getMovieSearchResults(searchText : String,pageNum: Int){
        
        //URL Source: https://developer.themoviedb.org/reference/search-movie
        do{
            let urlString = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(searchText)&page=\(pageNum)&include_adult=false&language=en-US&page=\(pageNum)&api_key=\(api_key)")
        
            
            let task = URLSession.shared.dataTask(with: urlString!) { data, response, error in
                
                if error != nil {
                    self.delegate?.networkingDidFinishWithError()
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)else {
                    self.delegate?.networkingDidFinishWithError()
                    return
                }
                
                // there is no error, there is a good response
                if let gooddata = data{
                    let decoder = JSONDecoder()
                    do {
                        let movieData =  try decoder.decode(MovieSearchResult.self, from: gooddata)
                        self.delegate?.networkingDidFinishWithMovies(movieSearchDetails: movieData.results)
                        
                    }catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getMovieDetails(movieId: Int){
        
        //URL Source: https://developer.themoviedb.org/reference/search-movie
        do{
            let urlString = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(api_key)")
            
            let task = URLSession.shared.dataTask(with: urlString!) { data, response, error in
                
                if error != nil {
                    self.delegate?.networkingDidFinishWithError()
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)else {
                    self.delegate?.networkingDidFinishWithError()
                    return
                }
                
                // there is no error, there is a good response
                if let gooddata = data{
                    let decoder = JSONDecoder()
                    do {
                        let movieDetail =  try decoder.decode(MovieDetail.self, from: gooddata)
                        self.delegate?.networkingDidFinishWithMovieDetails(movieDetail: movieDetail)
                        
                    }catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
}

