//
//  mostPopularMovies.swift
//  MovieQuiz
//
//  Created by Леонид Лебедев on 18.12.2025.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}
