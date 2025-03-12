//
//  UserAnswer.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import Foundation

struct UserAnswer: Codable, Equatable {
    let question: Question
    let selectAnswer: String
    
    static func == (lhs: UserAnswer, rhs: UserAnswer) -> Bool {
        return lhs.question.question == rhs.question.question
    }
}
