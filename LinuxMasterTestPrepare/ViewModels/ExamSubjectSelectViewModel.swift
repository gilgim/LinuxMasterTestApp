//
//  ExamSubjectSelectViewModel.swift
//  LinuxMasterTestPrepare
//
//  Created by gilgim on 3/1/25.
//

import Foundation

@Observable class ExamSubjectSelectViewModel {
    let examName: String
    var selectSubjects: [SubjectType] = [.subject1, .subject2, .subject3]
    var examData: [ExamData] = []
    init(examName: String) {
        self.examName = examName
        Task { @MainActor in
            self.examData = (try? SwiftDataManager.fetchAll(ofType: ExamData.self)) ?? []
            self.examData = self.examData.filter({$0.examName == examName})
        }
    }
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
    func checkPrevioseTest() -> Bool {
        return !(self.examData.filter({$0.examType == .previousPractice}).isEmpty)
    }
    func checkForceQuitTest() -> Bool {
        return !(self.examData.filter({$0.examType == .forceQuitPractice}).isEmpty)
    }
    func previousExamData() -> [ExamData] {
        return self.examData.filter({$0.examType == .previousPractice})
    }
    func forceQuitExamData() -> [ExamData] {
        return self.examData.filter({$0.examType == .forceQuitPractice})
    }
}
