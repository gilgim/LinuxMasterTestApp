//
//  ExamActionButton.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 3/12/25.
//

import SwiftUI

struct ExamActionButton: View {
    @Environment(ExamViewModel.self) var vm: ExamViewModel
    let questionData: Question
    var body: some View {
        if vm.isShowRetryButton(question: questionData) {
            Button(action: {
                vm.resetAnswer(question: questionData)
            }) {
                Image(systemName: "arrow.counterclockwise")
                Text("다시풀기")
                    .fontWeight(.medium)
            }
            .buttonStyle(ExamActionButtonStyle(activeColor: .blue))
        } else if vm.isShowConfirmButton(question: questionData) {
            Button(action: {
                self.vm.confirmAnswer(question: questionData)
            }) {
                Image(systemName: "checkmark.circle")
                Text("정답 확인하기")
                    .fontWeight(.medium)
            }
            .buttonStyle(ExamActionButtonStyle(activeColor: .green))
        } else if vm.isShowGrade(question: questionData) {
            Button(action: {
                self.vm.allConfirmAnswer()
            }) {
                Image(systemName: "checkmark")
                Text("채점하기")
                    .fontWeight(.medium)
            }
            .buttonStyle(ExamActionButtonStyle(activeColor: .green))
            .padding(.top, 20)
        }
    }
    struct ExamActionButtonStyle: ButtonStyle {
        let activeColor: Color
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.label
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(activeColor.opacity(0.1))
            .foregroundColor(activeColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(activeColor, lineWidth: 1)
            )
        }
    }
}
#Preview {                            
    let vm = ExamViewModel(examName: "2015_03_14", examType: .test, selectSubject: [.subject1, .subject2, .subject3])
    let question = vm.questions().last!
    ExamActionButton(questionData: question)
        .environment(vm)
}
