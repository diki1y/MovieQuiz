import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    private var correctAnswers = 0
    private var currntQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDependencies()
        loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else { return }
        showAnswerResult(isCorect: !currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else { return }
        showAnswerResult(isCorect: currentQuestion.correctAnswer)
    }
    
    private func setupUI() {
        imageView.layer.cornerRadius = 20
    }
    
    private func setupDependencies() {
        questionFactory = QuestionFactory(
            moviesLoader: MoviesLoader(),
            delegate: self
        )
        statisticService = StatisticService()
    }
    
    private func loadData() {
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image)
            ?? UIImage(named: "imagePlaceholder")
            ?? UIImage()

        return QuizStepViewModel(
            image: image,
            question: model.text,
            questionNumber: "\(currntQuestionIndex + 1)/\(questionsAmount)"
        )
    }

    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
    }
    
    private func showAnswerResult(isCorect:Bool){
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if isCorect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQestionOrResults()
        }
        
    }
    
    private func showNextQestionOrResults() {
        if currntQuestionIndex == questionsAmount - 1 {
            let text = "Ваш результат: \(correctAnswers)"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз ")
            
            show(quiz: viewModel)
        } else {
            currntQuestionIndex += 1
            showLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let correct = correctAnswers
        let total = questionsAmount
        
        statisticService.store(correct: correct, total: total)
        
        let message = """
        Ваш результат: \(correct)/\(total)
        Всего игр сыграно: \(statisticService.gamesCount)
        Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        
        let model = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText
        ) { [weak self] in
            guard let self else { return }
            
            self.currntQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        
        AlertPresenter.show(in: self, model: model)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message:String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Error", message: message, buttonText: "Try again") { [weak self] in guard let self = self else { return }
            self.currntQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        AlertPresenter.show(in: self, model: model)
        
    }
    private func makeErrorMessage(from error: Error) -> String {
        let nsError = error as NSError

        if nsError.domain == NSURLErrorDomain {
            return "Нет соединения с интернетом"
        } else {
            return "Что-то пошло не так. Попробуйте позже"
        }
    }

}

    extension MovieQuizViewController: QuestionFactoryDelegate {
        
        func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            currentQuestion = question
            let viewModel = convert(model: question)
            
            DispatchQueue.main.async { [weak self] in
                self?.hideLoadingIndicator()
                self?.show(quiz: viewModel)
            }
        }
        
        func didLoadDataFromServer() {
            activityIndicator.isHidden = true
            questionFactory?.requestNextQuestion()
        }
        
        func didFailToLoadData(with error: Error) {
            let message = makeErrorMessage(from: error)
            showNetworkError(message: message)
        }

        
}
