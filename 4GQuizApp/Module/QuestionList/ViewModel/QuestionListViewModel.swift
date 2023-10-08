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
    @Published var quiz: Quiz?
    @Published var quizDetail: QuizDetailModel?
    @Published var quizDetailFromCache: QuizDetailModel?
    @Published var tags: [Tags] = []
    
    /// Progress loading
    @Published var isLoading: Bool = false
    @Published var viewStates: ViewStates = ViewStates.ready
    @Published var isCacheIsEmpty: Bool = false
    
    init() {
        self.loadedData()
        self.getCurrentQuizzesFromCache()
        self.getQuizDetailFromCache()
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
            let result = await DIProvider.quizRepository.getQuizList()
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
            let result = await DIProvider.quizRepository.getDetailQuiz(quizId: quizId)
            switch result {
            case .success(let success):
                self.quizDetail = success
                self.saveQuizDetailToCache(value: success)
                setViewState(to: .ready)
            case .failure(let failure):
                print("DEBUG: error get data \(failure.localizedDescription)")
                setViewState(to: .error)
            }
        }
    }
    
    private func saveQuizzesToCache(value: [Quiz]) {
        setViewState(to: .loading)
        DIProvider.quizCacheRepository.saveQuizzesToCache(key: .quizzes, value: value)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.setViewState(to: .ready)
                    self.isCacheIsEmpty = true
                    print("DEBUG: UPDATE_QUIZZES_TO_CACHE 🔥")
                case .failure(let cacheError):
                    switch cacheError {
                    case .failedToSave:
                        self.setViewState(to: .error)
                        print("DEBUG: Failed SAVE_QUIZZES_TO_Cache")
                    case .failedToRetrieve(let error):
                        self.setViewState(to: .error)
                        print("DEBUG: Failed to retrieve  \(String(describing: error))")
                    }
                }
            }, receiveValue: { state in
            }).store(in: &self.bag)
    }
    
    private func getCurrentQuizzesFromCache() {
        //setViewState(to: .loading)
        DIProvider.quizCacheRepository.getQuizzesFromCache(key: .quizzes)
            .sink(receiveCompletion: {_ in }, receiveValue: { [weak self] values in
                guard let self = self else { return }
                self.questionsFromCache = values
                print("DEBUG: GET_QUIZ_OBJECT_FROM_CACHE 🔥 = \(values) ")
            }).store(in: &self.bag)
    }
    
    private func saveQuizDetailToCache(value: QuizDetailModel) {
        setViewState(to: .loading)
        DIProvider.quizCacheRepository.saveQuizDetail(key: .quizDetail, value: value)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("DEBUG: UPDATE_QUIZ_TO_CACHE 🔥")
                    self.getQuizDetailFromCache()
                case .failure(let cacheError):
                    switch cacheError {
                    case .failedToSave:
                        print("DEBUG: Failed SAVE_QUIZ_TO_Cache")
                    case .failedToRetrieve(let error):
                        print("DEBUG: Failed to retrieve  \(String(describing: error))")
                    }
                }
            }, receiveValue: { state in
            }).store(in: &self.bag)
    }
    
    func getQuizDetailFromCache() {
        DIProvider.quizCacheRepository.getQuizDetail(key: .quizDetail)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.quizDetailFromCache = value
                print("DEBUG: GET_QUIZ_DETAIL_OBJECT_FROM_CACHE 🔥 = \(value) ")
            }).store(in: &self.bag)
    }
}
