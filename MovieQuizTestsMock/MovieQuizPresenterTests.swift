//
//  MovieQuizPresenterTests.swift
//  MovieQuizTestsMock
//
//  Created by Леонид Лебедев on 24.12.2025.
//


import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {

    func testPresenterConvertModel() throws {
        // given
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(
            image: emptyData,
            text: "Question Text",
            correctAnswer: true
        )

        // when
        let viewModel = sut.convert(model: question)

        // then
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
