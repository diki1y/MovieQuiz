//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Леонид Лебедев on 21.12.2025.
//

import Foundation

protocol NetworkRouting {
    func fetch(
        url: URL,
        handler: @escaping (Result<Data, Error>) -> Void
    )
}
