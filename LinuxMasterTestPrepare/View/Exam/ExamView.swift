//
//  ExamView.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import SwiftUI

struct ExamView: View {
    enum ExamAlert: Identifiable {
        case cancel, save, complete
        var id: Int { hashValue }
    }
    //  MARK: Property
    //  -Environment
    @Environment(NavigationData.self) var navigationData
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    
    //  -State
    @State private var activeAlert: ExamAlert?
    @State var showQuestionPicker: Bool = false
    @State var vm: ExamViewModel
    
    init(vm: ExamViewModel = .init(examName: "2015_03_14", examType: .test, selectSubject: [.subject1, .subject2, .subject3])) {
        self.vm = vm
    }
    var body: some View {
        HStack {
            TabView(selection: $vm.currentQuestion) {
                let questions = vm.questions()
                ForEach(0..<questions.count, id: \.self) { index in
                    let questionData = questions[index]
                    VStack(alignment: .leading) {
                        //  문제
                        ExamAnswerTitleView(questionNumber: index, questionData: questionData)
                            .environment(vm)
                        // 보기 선택지
                        ExamAnswerListView(questionData: questionData)
                            .environment(vm)
                        // 채점 및 정답 이벤트 뷰
                        ExamActionButton(questionData: questionData)
                            .environment(vm)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 16)
                    .tag(index)
                }
            }
            .overlay(
                Button(action: {
                    showQuestionPicker.toggle()
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title)
                        .padding()
                        .background(Color.purple.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(),
                alignment: .bottomTrailing
            )
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                break
            case .inactive:
                break
            case .background:
                break
            @unknown default:
                print("알 수 없는 상태")
            }
        }
        //  MARK: Alert
        .sheet(isPresented: $showQuestionPicker) {
            ExamJumpQuestionView()
                .environment(vm)
        }
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .cancel:
                return Alert(
                    title: Text("시험을 취소하시겠습니까?"),
                    primaryButton: .cancel(Text("취소")),
                    secondaryButton: .default(Text("확인"), action: {
                        navigationData.path = .init()
                    })
                )
            case .save:
                return Alert(
                    title: Text("시험을 저장하시겠습니까?"),
                    primaryButton: .cancel(Text("아니오"), action: {
                        navigationData.path = .init()
                    }),
                    secondaryButton: .default(Text("예"), action: {
                        navigationData.path = .init()
                    })
                )
            case .complete:
                return Alert(
                    title: Text("시험을 완료하시겠습니까?"),
                    primaryButton: .cancel(Text("취소")),
                    secondaryButton: .default(Text("확인"), action: {
                        // 완료 액션 실행
                    })
                )
            }
        }
        //  MARK: Style
        .modifier(ExamViewStyle(navigationData: _navigationData, vm: $vm, activeAlert: $activeAlert))
    }
    private struct ExamViewStyle: ViewModifier {
        @Environment(NavigationData.self) var navigationData
        @Binding var vm: ExamViewModel
        @Binding var activeAlert: ExamAlert?
        func body(content: Content) -> some View {
            content
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            if vm.isTestFinish {
                                self.navigationData.path = .init()
                            } else {
                                self.activeAlert = .cancel
                            }
                        }) {
                            Image(systemName: "arrow.backward")
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
        }
    }
}

#Preview {
    NavigationStack {
        ExamView()
            .environment(NavigationData())
    }
}
