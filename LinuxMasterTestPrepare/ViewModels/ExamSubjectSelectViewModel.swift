//
//  ExamSubjectSelectViewModel.swift
//  LinuxMasterTestPrepare
//
//  Created by gilgim on 3/1/25.
//

import Foundation

@Observable class ExamSubjectSelectViewModel {
    //  MARK: Private Property
    private(set) var selectSubjects: [SubjectType] = [.subject1, .subject2, .subject3]
    private(set) var examData: [ExamData] = []
    
    //  MARK: Public Property
    public let examName: String
    init(examName: String) {
        self.examName = examName
        Task { @MainActor in
            self.examData = (try? SwiftDataManager.fetchAll(ofType: ExamData.self)) ?? []
            self.examData = self.examData.filter({$0.examName == examName})
        }
    }
    //  MARK: Actions
    func selectSubject(type: SubjectType) -> Bool {
        if let index = selectSubjects.firstIndex(where: { $0 == type }) {
            if selectSubjects[index] == type {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    func checkSubject(type: SubjectType) {
        if let index = selectSubjects.firstIndex(where: { $0 == type }) {
            if selectSubjects[index] == type {
                selectSubjects.remove(at: index)
            } else {
                selectSubjects.append(type)
            }
        } else {
            selectSubjects.append(type)
        }
    }
    //  MARK: Views
    func checkPrevioseTest() -> Bool {
        return !(self.examData.filter({$0.examType == .previousPractice}).isEmpty)
    }
    func checkForceQuitTest() -> Bool {
        return !(self.examData.filter({$0.examType == .forceQuitPractice}).isEmpty)
    }
    //  MARK: Datas
    func questions(subjectType: SubjectType) -> [Question] {
        let question = Util.parseJSON(fromFile: self.examName, to: [Question].self) ?? []
        var resultQuestion: [Question] = []
        switch subjectType {
        case .subject1:
            for i in 0..<20 {
                resultQuestion.append(question[i])
            }
        case .subject2:
            for i in 20..<60 {
                resultQuestion.append(question[i])
            }
        case .subject3:
            for i in 60..<100 {
                resultQuestion.append(question[i])
            }
        }
        return resultQuestion
    }
    func subjectIncorrectRate(subjectType: SubjectType) -> String {
        // 대상 문제 배열: examName 파일에서 subjectType에 해당하는 문제들
        let targetQuestions = self.questions(subjectType: subjectType)
        var total = 0
        var incorrect = 0
        // examData 배열의 각 데이터를 순회
        for data in self.examData {
            // 각 examData의 confirmAnswers를 확인
            for confirmAnswer in data.confirmAnswers {
                // 해당 문제(확인용 질문)가 대상 문제 배열에 포함되어 있는지 확인
                if targetQuestions.contains(where: { $0 == confirmAnswer.question }) {
                    total += 1
                    // userAnswers에서 해당 질문에 대한 답변을 찾음
                    if let userAnswer = data.userAnswers.first(where: { $0.question == confirmAnswer.question }) {
                        // 사용자 답변이 정답과 다르면 오답으로 처리
                        if userAnswer.selectAnswer != confirmAnswer.selectAnswer {
                            incorrect += 1
                        }
                    } else {
                        // 사용자가 답변을 제출하지 않았다면 오답으로 간주
                        incorrect += 1
                    }
                }
            }
        }
        
        guard total > 0 else { return "-" }
        return "\(incorrect * 100 / total)%"
    }
    func subjectCorrectRate(subjectType: SubjectType) -> String {
        // 대상 문제 배열: examName 파일에서 subjectType에 해당하는 문제들
        let targetQuestions = self.questions(subjectType: subjectType)
        var total = 0
        var correct = 0
        // examData 배열의 각 데이터를 순회
        for data in self.examData {
            // 각 examData의 confirmAnswers를 확인
            for confirmAnswer in data.confirmAnswers {
                // 해당 문제(확인용 질문)가 대상 문제 배열에 포함되어 있는지 확인
                if targetQuestions.contains(where: { $0 == confirmAnswer.question }) {
                    total += 1
                    // userAnswers에서 해당 질문에 대한 답변을 찾음
                    if let userAnswer = data.userAnswers.first(where: { $0.question == confirmAnswer.question }) {
                        // 사용자 답변이 정답과 다르면 오답으로 처리
                        if userAnswer.selectAnswer == confirmAnswer.selectAnswer {
                            correct += 1
                        }
                    }
                }
            }
        }
        guard total > 0 else { return "-" }
        return "\(correct * 100 / total)%"
    }
    func previousExamData() -> [ExamData] {
        return self.examData.filter({$0.examType == .previousPractice})
    }
    func forceQuitExamData() -> [ExamData] {
        return self.examData.filter({$0.examType == .forceQuitPractice})
    }
}
