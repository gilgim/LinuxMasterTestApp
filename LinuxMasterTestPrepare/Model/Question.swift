//
//  QuestionStruct.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import Foundation

struct Question: Codable, Equatable {
    let question: String
    let options: [String]
    let correctAnswer: String
    let image: String?
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.question == rhs.question &&
        lhs.options == rhs.options &&
        lhs.correctAnswer == rhs.correctAnswer &&
        lhs.image == rhs.image
    }
}
