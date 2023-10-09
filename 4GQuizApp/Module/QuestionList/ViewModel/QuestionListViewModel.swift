//
//  QuestionListViewModel.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI
import Combine

@MainActor
final class QuestionListViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    @Published var questions: [Quiz] = []
    @Published var questionsFromCache: [Quiz] = []
    @Published var quizDetail: QuizDetailModel?
    @Published var quizDetailFromCache: QuizDetailModel?
    
    /// Progress loading
    @Published var isLoading: Bool = false
    @Published var viewStates: ViewStates = ViewStates.ready
    @Published var isCacheIsEmpty: Bool = false
    @Published var currentQuiz: LastQuiz?
    
    /// show alert quiz
    @Published var isShowAlertQuiz: Bool = false
    
    @Published var isContinueLastQuiz: Bool = false
    @Published var isPresentDetailView: Bool = false
    
    /// Repositories
    @Published private var cacheRepository = DIProvider.quizCacheRepository
    @Published private var quizRepository = DIProvider.quizRepository
    
    var curentState = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        self.checkIfCurrentQuizIsPending()
        self.loadedData()
        self.getCurrentQuizzesFromCache()
        self.getQuizDetailFromCache()
        
        setupQuiz()
    }
    
    func setupQuiz() {
        if currentQuiz?.isCompleted != nil {
            isShowAlertQuiz.toggle()
        }
    }
    
    func setNewQuiz() {
        self.isShowAlertQuiz = false
        cacheRepository.clearCache(key: .lastQuiz)
    }
    
    func setLastQuiz() {
        self.isShowAlertQuiz = false
        self.isContinueLastQuiz = true
        self.isPresentDetailView.toggle()
    }
    
    private func setViewState(to state: ViewStates) {
        DispatchQueue.main.async {
            self.viewStates = state
            self.isLoading = state == .loading
            
            switch state {
            case .empty, .ready, .error:
                self.isLoading = false
            case .loading:
                self.isLoading = true
            }
        }
    }
    
    func loadedData() {
        setViewState(to: .loading)
        Task {
            let result = await quizRepository.getQuizList()
            switch result {
            case .success(let success):
                self.questions = success.items
                self.saveQuizzesToCache(value: success.items)
                setViewState(to: .ready)
            case .failure(let failure):
                print("DEBUG: error get data \(failure.localizedDescription)")
                setViewState(to: .error)
            }
        }
    }

    func getDetailQuiz(quizId: Int) {
        setViewState(to: .loading)
        Task {
            let result = await quizRepository.getDetailQuiz(quizId: quizId)
            switch result {
            case .success(let success):
                self.quizDetail = success
                self.saveQuizDetailToCache(value: success)
                setViewState(to: .ready)
            case .failure(let failure):
                print("DEBUG: ERROR_GET_DATAIL_QUIZ_DATA \(failure.localizedDescription)")
                setViewState(to: .error)
            }
        }
    }
    
    private func saveQuizzesToCache(value: [Quiz]) {
        setViewState(to: .loading)
        cacheRepository.saveQuizzesToCache(key: .quizzes, value: value)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.setViewState(to: .ready)
                    self.isCacheIsEmpty = true
                case .failure(let cacheError):
                    switch cacheError {
                    case .failedToSave:
                        self.setViewState(to: .error)
                        print("DEBUG: Failed SAVE_QUIZZES_TO_CACHE")
                    case .failedToRetrieve(let error):
                        self.setViewState(to: .error)
                        print("DEBUG: Failed to retrieve  \(String(describing: error))")
                    }
                }
            }, receiveValue: { state in
            }).store(in: &self.bag)
    }
    
    private func getCurrentQuizzesFromCache() {
        cacheRepository.getQuizzesFromCache(key: .quizzes)
            .sink(receiveCompletion: {_ in }, receiveValue: { [weak self] values in
                guard let self = self else { return }
                self.questionsFromCache = values
            }).store(in: &self.bag)
    }
    
    private func saveQuizDetailToCache(value: QuizDetailModel) {
        setViewState(to: .loading)
        cacheRepository.saveQuizDetail(key: .quizDetail, value: value)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.getQuizDetailFromCache()
                case .failure(let cacheError):
                    switch cacheError {
                    case .failedToSave:
                        print("DEBUG: Failed SAVE_QUIZ_TO_CACHE")
                    case .failedToRetrieve(let error):
                        print("DEBUG: Failed to retrieve  \(String(describing: error))")
                    }
                }
            }, receiveValue: { state in
            }).store(in: &self.bag)
    }
    
    func getQuizDetailFromCache() {
        cacheRepository.getQuizDetail(key: .quizDetail)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.quizDetailFromCache = value
            }).store(in: &self.bag)
    }
    
    /// Check last quiz state
    func checkIfCurrentQuizIsPending() {
        cacheRepository.getCurrentStateQuiz(key: .lastQuiz)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.currentQuiz = value
            }).store(in: &self.bag)
    }
}
