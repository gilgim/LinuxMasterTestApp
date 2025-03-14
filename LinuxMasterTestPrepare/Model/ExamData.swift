//
//  ExamData.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 3/5/25.
//

import SwiftData
import Foundation

@Model class ExamData: SwiftDataModel {
    var id: UUID
    var examName: String
    
    var examTypeString: String
    var examType: ExamType {
        get {
            return ExamType(rawValue: examTypeString)!
        }
        set {
            self.examTypeString = newValue.rawValue
        }
    }
    
    var userAnswersData: Data?
    var userAnswers: [UserAnswer] {
        get {
            if let userAnswersData {
                return Util.parseJSON(data: userAnswersData, to: [UserAnswer].self) ?? []
            } else {
                return []
            }
        }
        set {
            userAnswersData = Util.encodeJSON(from: newValue)
        }
    }
    
    var confirmAnswersData: Data?
    var confirmAnswers: [UserAnswer] {
        get {
            if let confirmAnswersData {
                return Util.parseJSON(data: confirmAnswersData, to: [UserAnswer].self) ?? []
            } else {
                return []
            }
        }
        set {
            confirmAnswersData = Util.encodeJSON(from: newValue)
        }
    }
    
    var selectSubjects: [String]
    var selectSubjectsTypes: [SubjectType] {
        return selectSubjects.map({SubjectType(rawValue: $0)!})
    }
    init(examName: String, examType: ExamType, userAnswers: [UserAnswer], confirmAnswers: [UserAnswer] = [], selectSubjects: [SubjectType]) {
        self.id = UUID()
        self.examName = examName
        self.examTypeString = examType.rawValue
        self.userAnswersData = Util.encodeJSON(from: userAnswers)
        self.selectSubjects = selectSubjects.map({$0.rawValue})
    }
    var description: String {
        return """
        ExamData:
          id: \(id)
          examName: \(examName)
          examType: \(examType)
          userAnswers: \(userAnswers)
          confirmAnswers: \(confirmAnswers)
          selectSubjects: \(selectSubjects)
        """
    }
}
