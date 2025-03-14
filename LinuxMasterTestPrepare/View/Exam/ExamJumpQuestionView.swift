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
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(vm.questions().indices, id: \.self) { index in
                        Button(action: {
                            jumpToQuestion(index: index)
                        }) {
                            VStack {
                                Text("문제 \(index + 1)")
                                    .modifier(ExamJumpComponentStyle(vm: _vm, index: index))
                            }
                        }
                    }
                }
                .padding()
            }
            .modifier(ExamJumpQuestionViewStyle(dismiss: _dismiss))
        }
    }
    //  MARK: -Function
    func jumpToQuestion(index: Int) {
        vm.currentQuestion = index
        dismiss()
    }
    //  MARK: -Style
    //  전체화면 스타일
    struct ExamJumpQuestionViewStyle: ViewModifier {
        @Environment(\.dismiss) var dismiss
        func body(content: Content) -> some View {
            content
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
    //  셀 스타일
    struct ExamJumpComponentStyle: ViewModifier {
        @Environment(ExamViewModel.self) var vm
        let index: Int
        func body(content: Content) -> some View {
            let questions = vm.questions()
            let questionData = questions[index]
            let pointColor = self.vm.jumpQuestionTextColor(question: questionData)
            let backgroundColor = self.vm.jumpQuestionBackGroundColor(question: questionData)
            let selectWidth = self.vm.selectedJumpQuestionLineWidth(question: questionData)
            content
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

#Preview {
    let vm = ExamViewModel(examName: "2015_03_14", examType: .test, selectSubject: [.subject1, .subject2, .subject3])
    ExamJumpQuestionView()
        .environment(vm)
}
