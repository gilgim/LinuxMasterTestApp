//
//  ExamAnswerListView.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 3/12/25.
//

import SwiftUI

struct ExamAnswerListView: View {
    @Environment(ExamViewModel.self) var vm: ExamViewModel
    let questionData: Question
    var body: some View {
        let questionOptions = questionData.options
        VStack(spacing: 10) {
            ForEach(0..<questionOptions.count, id: \.self) { idx in
                let backgroundColor = self.vm.questionOptionBackGroundColor(question: questionData, optionAnswer: questionOptions[idx])
                let lineWidth = self.vm.selectQuestionLineWidth(question: questionData, optionAnswer: questionOptions[idx])
                HStack {
                    Text("\(idx+1). \(questionOptions[idx])")
                        .font(.body)
                        .padding(.leading, 8)
                    Spacer()
                }
                .padding()
                .background(backgroundColor)
                .cornerRadius(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: lineWidth)
                )
                .onTapGesture {
                    self.vm.checkAnswer(question: questionData, optionAnswer: questionOptions[idx])
                }
            }
        }
    }
}
#Preview {
    let vm = ExamViewModel(examName: "2015_03_14", examType: .test, selectSubject: [.subject1, .subject2, .subject3])
    let question = vm.questions().first!
    ExamAnswerListView(questionData: question)
        .environment(vm)
}
