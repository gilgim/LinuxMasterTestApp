//
//  Navigation.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import Foundation
import SwiftUI

@Observable class NavigationData {
    var path = NavigationPath()
}
enum NavigationPathKey: Hashable {
    case subjectSelect(examName: String)
    case exam(examName: String, examType: ExamType, subjectType: [SubjectType])
    case previousExam(examData: ExamData)
    case forceQuitExam(examData: ExamData)
}
