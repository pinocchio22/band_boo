// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct PopularMovieList {
    static var popularMovieList = PopularMovieList()
    var movieList: [MovieInfo]
    private init() {
        movieList = [MovieInfo(id: 0, title: "", posterPath: "", voteAverage: 0.0, voteCount: 0, popularity: 0.0)]
    }
}

struct MovieInfo {
    let id: Int
    let title: String
    let posterPath: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
}

struct Welcome: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
    let backdropPath: String?
    let id: Int
    let originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
