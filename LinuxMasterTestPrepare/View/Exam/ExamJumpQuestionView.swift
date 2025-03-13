//
//  ExamQuestionPickerView.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 3/12/25.
//
import SwiftUI

struct ExamJumpQuestionView: View {
    @Environment(ExamViewModel.self) var vm: ExamViewModel
    @Environment(\.dismiss) var dismiss
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 6), count: 4)
    var body: some View {
        let questions = vm.questions()
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(questions.indices, id: \.self) { index in
                        let questionData = questions[index]
                        let pointColor = self.vm.jumpQuestionTextColor(question: questionData)
                        let backgroundColor = self.vm.jumpQuestionBackGroundColor(question: questionData)
                        let selectWidth = self.vm.selectedJumpQuestionLineWidth(question: questionData)
                        Button(action: {
                            jumpToQuestion(index: index)
                        }) {
                            VStack {
                                Text("문제 \(index + 1)")
                                    .foregroundStyle(pointColor)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(15)
                                    .background(backgroundColor)
                                    .cornerRadius(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth: selectWidth)
                                            .foregroundStyle(pointColor)
                                    )
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("문제 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button (action:{
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
    }
    func jumpToQuestion(index: Int) {
        vm.currentQuestion = index
        dismiss()
    }
}

#Preview {
    let vm = ExamViewModel(examName: "2015_03_14", examType: .test, selectSubject: [.subject1, .subject2, .subject3])
    ExamJumpQuestionView()
        .environment(vm)
}
