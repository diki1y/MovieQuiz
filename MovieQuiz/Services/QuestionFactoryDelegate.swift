//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Леонид Лебедев on 08.12.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error) 
}
