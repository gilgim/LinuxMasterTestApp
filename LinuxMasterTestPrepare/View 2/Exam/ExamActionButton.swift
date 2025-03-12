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
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("다시풀기")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .foregroundColor(Color.blue)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
        } else if vm.isShowConfirmButton(question: questionData) {
            Button(action: {
                self.vm.confirmAnswer(question: questionData)
            }) {
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text("정답 확인하기")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.1))
                .foregroundColor(Color.green)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 1)
                )
            }
        } else if vm.isShowGrade(question: questionData) {
            Button(action: {
                self.vm.allConfirmAnswer()
            }) {
                HStack {
                    Image(systemName: "checkmark")
                    Text("채점하기")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.1))
                .foregroundColor(Color.green)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 1)
                )
            }
            .padding(.top, 20)
        }
    }
}
#Preview {                            
    let vm = ExamViewModel(examName: "2015_03_14", examType: .test, selectSubject: [.subject1, .subject2, .subject3])
    let question = vm.questions().first!
    ExamActionButton(questionData: question)
        .environment(vm)
}
