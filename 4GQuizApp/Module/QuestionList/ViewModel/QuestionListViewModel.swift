//
//  QuestionListViewModel.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

@MainActor
final class QuestionListViewModel: ObservableObject {
    @Published var questions: [Quiz] = []
    @Published var quiz: Quiz?
    @Published var quizDetail: QuizDetailModel?
    @Published var tags: [Tags] = []
    
    /// Progress loading
    @Published var isLoading: Bool = false
    @Published var viewStates: ViewStates = ViewStates.ready
    
    init() {
        loadedData()
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
                setViewState(to: .ready)
            case .failure(let failure):
                print("DEBUG: error get data \(failure.localizedDescription)")
                setViewState(to: .error)
            }
        }
    }
}
