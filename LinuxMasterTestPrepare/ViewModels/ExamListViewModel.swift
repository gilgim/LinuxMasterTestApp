//
//  ExamListViewModel.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import Foundation

@Observable
class ExamListViewModel {
    func listName() -> [String] {
        return Util.getJSONFileNames().map {$0.replacingOccurrences(of: ".json", with: "")}.sorted(by: {$0 > $1})
    }
    func examIncorrectRate(examName: String) async -> Int? {
        let examDatas = (try? await SwiftDataManager.fetchAll(ofType: ExamData.self)) ?? []
        let filteredExamDatas = examDatas.filter { $0.examName == examName }
        
        // 해당 시험 이름에 해당하는 데이터가 하나도 없으면 nil 반환
        guard !filteredExamDatas.isEmpty else { return nil }
        
        var totalConfirmCount = 0
        var totalIncorrectCount = 0
        
        // 모든 해당 시험 데이터에 대해 오답과 총 문제 수를 누적
        for examData in filteredExamDatas {
            let confirmCount = examData.confirmAnswers.count
            // confirmAnswers가 없는 경우는 건너뜁니다.
            guard confirmCount > 0 else { continue }
            totalConfirmCount += confirmCount
            
            for confirmAnswer in examData.confirmAnswers {
                let correctAnswer = confirmAnswer.selectAnswer
                // 사용자 답안이 존재하면 비교, 없으면 오답으로 처리
                if let userAnswer = examData.userAnswers.first(where: { $0.question == confirmAnswer.question }) {
                    if userAnswer.selectAnswer != correctAnswer {
                        totalIncorrectCount += 1
                    }
                } else {
                    totalIncorrectCount += 1
                }
            }
        }
        
        guard totalConfirmCount > 0 else { return nil }
        
        return totalIncorrectCount * 100 / totalConfirmCount
    }
    func examCorrectRate(examName: String) async -> Int? {
        let examDatas = (try? await SwiftDataManager.fetchAll(ofType: ExamData.self)) ?? []
        let filteredExamDatas = examDatas.filter { $0.examName == examName }
        
        // 해당 examName에 해당하는 데이터가 하나도 없으면 nil 반환
        guard !filteredExamDatas.isEmpty else { return nil }
        
        var totalConfirmCount = 0
        var totalCorrectCount = 0
        
        for examData in filteredExamDatas {
            let confirmCount = examData.confirmAnswers.count
            guard confirmCount > 0 else { continue }
            totalConfirmCount += confirmCount
            
            for confirmAnswer in examData.confirmAnswers {
                let correctAnswer = confirmAnswer.selectAnswer
                if let userAnswer = examData.userAnswers.first(where: { $0.question == confirmAnswer.question }) {
                    if userAnswer.selectAnswer == correctAnswer {
                        totalCorrectCount += 1
                    }
                }
            }
        }
        
        guard totalConfirmCount > 0 else { return nil }
        
        return totalCorrectCount * 100 / totalConfirmCount
    }
    func examTestCount(examName: String) async -> Int?{
        let examDatas = (try? await SwiftDataManager.fetchAll(ofType: ExamData.self)) ?? []
        let count = examDatas.filter({$0.examName == examName && $0.examType == .testComplete}).count
        if count <= 0 {
            return nil
        } else {
            return count
        }        
    }
    func examPracticeCount(examName: String) async -> Int? {
        let examDatas = (try? await SwiftDataManager.fetchAll(ofType: ExamData.self)) ?? []
        let count = examDatas.filter({$0.examName == examName && $0.examType == .practiceComplete}).count
        if count <= 0 {
            return nil
        } else {
            return count
        }
    }
}
