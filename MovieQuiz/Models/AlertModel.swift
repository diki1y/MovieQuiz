//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Леонид Лебедев on 08.12.2025.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: (() -> Void)
}
