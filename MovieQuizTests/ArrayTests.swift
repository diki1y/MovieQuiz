//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Леонид Лебедев on 21.12.2025.
//

import Foundation
import Testing
@testable import MovieQuiz

struct ArrayTests {

    @Test
    func getValueInRange() {
        // Given
        let array = [1, 1, 2, 3, 5]

        // When
        let value = array[safe: 2]

        // Then
        #expect(value != nil)
        #expect(value == 2)
    }

    @Test
    func getValueOutOfRange() {
        // Given
        let array = [1, 1, 2, 3, 5]

        // When
        let value = array[safe: 20]

        // Then
        #expect(value == nil)
    }
}
