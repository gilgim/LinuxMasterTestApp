//
//  Untitled.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import Foundation
import SwiftUI

@Observable
class ExamViewModel {
    enum ExamAlert: Identifiable {
        case cancel, save, complete, allCheck
        var id: Int { hashValue }
    }
    
    //  MARK: Private Property
    //  이전부터 진행됐던 시험
    private var examData: ExamData
    //  신규 시험 이름
    private let examName: String
    //  신규 시험 타입
    private let examType: ExamType
    //  신규 시험 선택 과목
    private var selectSubject: [SubjectType]
    //  푼 문제
    private var userAnswers: [UserAnswer] = []
    //  정답을 확인한 문제
    private var confirmAnswers: [UserAnswer] = []
    private var isPractice: Bool { return (self.examType == .practice || self.examType == .previousPractice || self.examType == .forceQuitPractice) }
    
    //  MARK: Public Property
    public var activeAlert: ExamAlert?
    public var currentQuestion: Int = 0
    public var isAnsweredQuestion: Bool { return !(userAnswers.isEmpty)}
    public var isTestFinish: Bool { return confirmAnswers.count == self.questions().count }
    public var isCheckFinish: Bool { return userAnswers.count == self.questions().count }
    init(examData: ExamData? = nil, examName: String? = nil, examType: ExamType? = nil, selectSubject: [SubjectType] = []) {
        //  시험을 이어서 보는 경우
        if let examData {
            self.examName = examData.examName
            self.examType = examData.examType
            self.selectSubject = examData.selectSubjectsTypes
            self.examData = examData
            self.userAnswers = examData.userAnswers
            self.confirmAnswers = examData.confirmAnswers
        //  시험을 신규로 보는 경우
        } else if let examName, let examType {
            self.examName = examName
            self.examType = examType
            self.selectSubject = selectSubject
            self.examData = .init(examName: examName, examType: examType, userAnswers: [], selectSubjects: selectSubject)
            Task { @MainActor in
                try? SwiftDataManager.create(self.examData)
            }
        //  필수 초기화
        } else {
            self.examName = "examName"
            self.examType = .practice
            self.selectSubject = selectSubject
            self.examData = .init(examName: "examName", examType: .practice, userAnswers: [], selectSubjects: selectSubject)
        }
    }
    //  문제정보
    func questions() -> [Question] {
        let question = Util.parseJSON(fromFile: self.examName, to: [Question].self) ?? []
        var resultQuestion: [Question] = []
        if selectSubject.contains(.subject1) {
            for i in 0..<20 {
                resultQuestion.append(question[i])
            }
        }
        if selectSubject.contains(.subject2) {
            for i in 20..<60 {
                resultQuestion.append(question[i])
            }
        }
        if selectSubject.contains(.subject3) {
            for i in 60..<100 {
                resultQuestion.append(question[i])
            }
        }
        return resultQuestion
    }
    //  MARK: Actions
    //  정답체크
    func checkAnswer(question: Question, optionAnswer: String) {
        guard !(self.confirmAnswers.contains(where: {$0.question == question})) else {return}
        if let index = userAnswers.firstIndex(where: { $0.question == question }) {
            if userAnswers[index].selectAnswer == optionAnswer {
                userAnswers.remove(at: index)
            } else {
                userAnswers[index] = .init(question: question, selectAnswer: optionAnswer)
            }
        } else {
            userAnswers.append(.init(question: question, selectAnswer: optionAnswer))
        }
    }
    //  정답확인
    func confirmAnswer(question: Question) {
        if let idx = self.questions().firstIndex(of: question), !(self.confirmAnswers.contains(where: {$0.question == question})) {
            self.confirmAnswers.append(.init(question: question, selectAnswer: self.questions()[idx].correctAnswer))
        }
        if isTestFinish {
            self.activeAlert = .complete
        }
    }
    //  전부 정답 체크
    func allConfirmAnswer() {
        let questions = questions()
        for question in questions {
            self.confirmAnswer(question: question)
        }
        self.finishExam()
    }
    //  문제초기화
    func resetAnswer(question: Question) {
        if let index = userAnswers.firstIndex(where: { $0.question == question }) {
            userAnswers.remove(at: index)
        }
        if let index = confirmAnswers.firstIndex(where: { $0.question == question }) {
            confirmAnswers.remove(at: index)
        }
    }
    //  MARK: Data
    //  시험 완료 저장
    private func finishExam() {
        Task { @MainActor in
            self.examData.userAnswers = self.userAnswers
            self.examData.confirmAnswers = self.confirmAnswers
            try SwiftDataManager.update(self.examData)
        }
    }
    //  시험 저장
    func saveExam() {
        Task { @MainActor in
            if isTestFinish {
                if self.isPractice {
                    self.examData.examType = .practiceComplete
                    self.examData.confirmAnswers = self.confirmAnswers
                } else {
                    self.examData.examType = .testComplete
                }
            } else {
                if self.isPractice {
                    self.examData.examType = .previousPractice
                    self.examData.confirmAnswers = self.confirmAnswers
                } else {
                    self.examData.examType = .previousTest
                }
            }
            self.examData.userAnswers = self.userAnswers
            try SwiftDataManager.update(self.examData)
        }
    }
    func cancelExam() {
        Task { @MainActor in
            try SwiftDataManager.delete(self.examData)
        }
    }
    //  강제 종료 방지
    func forcePreventExam() {
        Task { @MainActor in
            if self.isPractice {
                self.examData.examType = .forceQuitPractice
                self.examData.confirmAnswers = self.confirmAnswers
            } else {
                self.examData.examType = .forceQuitTest
            }
            self.examData.userAnswers = self.userAnswers
            try SwiftDataManager.update(self.examData)
        }
    }
    //  MARK: Views
    //  다시 풀기 버튼 노출
    func isShowRetryButton(question: Question) -> Bool {
        if isPractice {
            return self.confirmAnswers.contains(where: {$0.question == question})
        } else {
            return false
        }
    }
    //  정답확인 버튼 노출
    func isShowConfirmButton(question: Question) -> Bool {
        if isShowRetryButton(question: question) {
            return false
        } else {
            return isPractice
        }
    }
    //  채점하기 버튼 노출
    func isShowGrade(question: Question) -> Bool {
        if self.confirmAnswers.isEmpty {
            return self.questions().last == question
        } else {
            return false
        }
    }
    //  선택 보기 라인
    func selectQuestionLineWidth(question: Question, optionAnswer: String) -> CGFloat {
        if let index = userAnswers.firstIndex(where: { $0.question == question }) {
            if userAnswers[index].selectAnswer == optionAnswer {
                return 4
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    //  보기 배경
    func questionOptionBackGroundColor(question: Question, optionAnswer: String) -> Color {
        //  정답
        if let idx = self.confirmAnswers.firstIndex(where: {$0.question == question}) {
            if self.confirmAnswers[idx].selectAnswer == optionAnswer {
                //  유저가 풀었을 경우
                if self.userAnswers.contains(where: {$0.question == question}) {
                    return Color.green.opacity(0.35)
                //  유저가 안풀었을 경우
                } else {
                    return Color.red.opacity(0.35)
                }
            }
        }
        //  정답 아님
        if let idx = self.userAnswers.firstIndex(where: {$0.question == question}), self.confirmAnswers.contains(where: {$0.question == question}) {
            if self.userAnswers[idx].selectAnswer == optionAnswer {
                return Color.red.opacity(0.35)
            }
        }
        //  일반 보기
        return Color(UIColor.systemGray6)
    }
    //  이동 번호 배경
    func jumpQuestionBackGroundColor(question: Question) -> Color {
        //  정답 확인한 문제
        if self.confirmAnswers.contains(where: {$0.question == question}) {
            if let idx = userAnswers.firstIndex(where: {$0.question == question}) {
                let correctAnswer = userAnswers[idx].question.correctAnswer
                let userSelectAnswer = userAnswers[idx].selectAnswer
                //  정답확인
                if correctAnswer == userSelectAnswer {
                    return Color.green.opacity(0.35)
                } else {
                    return Color.red.opacity(0.35)
                }
            }
            else {
                return Color.red.opacity(0.35)
            }
        }
        return Color(UIColor.systemGray6)
    }
    //  이동 배경 텍스트
    func jumpQuestionTextColor(question: Question) -> Color {
        //  정답 확인한 문제
        if self.confirmAnswers.contains(where: {$0.question == question}) {
            if let idx = userAnswers.firstIndex(where: {$0.question == question}) {
                let correctAnswer = userAnswers[idx].question.correctAnswer
                let userSelectAnswer = userAnswers[idx].selectAnswer
                //  정답확인
                if correctAnswer == userSelectAnswer {
                    return Color.green
                } else {
                    return Color.red
                }
            } else {
                return Color.red
            }
        }
        //  푼 문제
        if userAnswers.contains(where: { $0.question == question }) {
            return Color(UIColor.black.withAlphaComponent(0.87))
        }
        return Color(UIColor.systemGray2)
    }
    //  이동 배경 라인
    func selectedJumpQuestionLineWidth(question: Question) -> CGFloat {
        if userAnswers.contains(where: { $0.question == question }) {
            return 4
        } else {
            return 0
        }
    }
}
