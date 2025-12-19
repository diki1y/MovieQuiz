//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Леонид Лебедев on 10.12.2025.
//

import Foundation

final class StatisticService {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
}

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let correct = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        let total = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        
        guard total > 0 else { return 0 }
        return (Double(correct) / Double(total)) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let correctAnswers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        storage.set(correctAnswers + count, forKey: Keys.totalCorrectAnswers.rawValue)
        
        let totalQuestions = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        storage.set(totalQuestions + amount, forKey: Keys.totalQuestionsAsked.rawValue)
        
        gamesCount += 1
        
        let newGame = GameResult(correct: count, total: amount, date: Date())
        
        if newGame.isBetterThan(bestGame) {
            bestGame = newGame
        }
    }
}
