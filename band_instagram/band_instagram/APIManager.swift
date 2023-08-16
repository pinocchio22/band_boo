//
//  APIManager.swift
//  band_instagram
//
//  Created by t2023-m0056 on 2023/08/09.
//

import UIKit

struct APIManager {
    enum MovieDownloadError: Error {
        case invalidURLString
        case invalidServerResponse
    }
    
    let myKey = APIKEY().myKey
    
    func getMovie() async throws -> [MovieInfo] {
        var list = [MovieInfo]()
        //popular
        // url setting
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(myKey)") else {
            throw MovieDownloadError.invalidURLString
        }
        // select URLSession
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieDownloadError.invalidServerResponse
        }
        let popularMovie = try JSONDecoder().decode(Welcome.self, from: data)
        popularMovie.results.forEach { movie in
            list.append(MovieInfo(id: movie.id, title: movie.originalTitle, posterPath: "https://image.tmdb.org/t/p/original\(movie.posterPath ?? "")", voteAverage: movie.voteAverage, voteCount: movie.voteCount, popularity: movie.popularity))
        }
        print(list)
        return list
    }
    
//    func getMovie(_ completion: @escaping ([MovieInfo]) -> Void) {
//        
//        guard let url = URL(string: "url") else {
//            return
//        }
//        
//        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//            guard let data = data, let responseData = try? JSONDecoder().decode(Welcome.self, from: data) else { return }
//            let movieData = responseData.results.map { movie in
//                MovieInfo(
//                    id: movie.id,
//                    title: movie.originalTitle,
//                    posterPath: movie.posterPath!,
//                    voteAverage: movie.voteAverage,
//                    voteCount: movie.voteCount,
//                    popularity: movie.popularity
//                )
//            }
//            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//                
//                completion(movieData)
//            }.resume()
//            
//        }.resume()
//    }
    
    func searchMovie(_ keyword: String) async throws -> [MovieInfo] {
        var list = [MovieInfo]()
        // search
        guard let url = URL(string: ("https://api.themoviedb.org/3/search/movie?api_key=\(myKey)&query=\(keyword)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            throw MovieDownloadError.invalidURLString
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieDownloadError.invalidServerResponse
        }
        let popularMovie = try JSONDecoder().decode(Welcome.self, from: data)
        popularMovie.results.forEach { movie in
            list.append(MovieInfo(id: movie.id, title: movie.originalTitle, posterPath: "https://image.tmdb.org/t/p/original\(movie.posterPath ?? "")", voteAverage: movie.voteAverage, voteCount: movie.voteCount, popularity: movie.popularity))
        }
        return list
    }
}
