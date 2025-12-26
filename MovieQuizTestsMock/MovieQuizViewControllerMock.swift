//
//  MovieQuizTestsMock.swift
//  MovieQuizTestsMock
//
//  Created by Леонид Лебедев on 24.12.2025.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {
        
    }
    func show(quiz result: QuizResultsViewModel) {
        
    }
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    func showLoadingIndicator() {
        
    }
    func hideLoadingIndicator() {
        
    }
    func showNetworkError(message: String) {
        
    }
}
