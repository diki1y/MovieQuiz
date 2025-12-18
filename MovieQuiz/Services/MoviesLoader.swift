//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Леонид Лебедев on 18.12.2025.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(hundler: @escaping(Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
        
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(hundler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    hundler(.success(mostPopularMovies))
                } catch {
                    hundler(.failure(error))
                }
            case .failure(let error):
                hundler(.failure(error))
            }
        }
    }
}
