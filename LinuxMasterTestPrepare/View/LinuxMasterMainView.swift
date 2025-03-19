//
//  LinuxMasterMainView.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import SwiftUI

struct LinuxMasterMainView: View {
    @State var examListNavigationData = NavigationData()
    var body: some View {
        NavigationStack(path: $examListNavigationData.path) {
            ExamListView()
                .navigationTitle("시험 목록")
                .background(Color(.systemGroupedBackground))
                .environment(examListNavigationData)
                .toolbar {
                    // 오른쪽에 프로필 버튼: 사용자 정보 및 기타 기능으로 확장 가능
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // 프로필 열기 액션 (추후 추가될 뷰로 네비게이션)
                            Task { @MainActor in
                                for exam in (try? SwiftDataManager.fetchAll(ofType: ExamData.self)) ?? [] {
                                    try? SwiftDataManager.delete(exam)
                                }
                            }
                        } label: {
                            Image(systemName: "person.crop.circle")
                        }
                        .foregroundStyle(Color.accentColor)
                    }
                }
                .navigationDestination(for: NavigationPathKey.self) { navigationType in
                    switch navigationType {
                    case .exam(let examName, let examType, let selectSubject):
                        ExamView(vm: .init(examName: examName, examType: examType, selectSubject: selectSubject))
                            .environment(examListNavigationData)
                            .navigationTitle("시험 보기")
                    case .previousExam(let examData):
                        ExamView(vm: .init(examData: examData, examType: .previousPractice))
                            .environment(examListNavigationData)
                            .navigationTitle("시험 보기")
                    case .forceQuitExam(let examData):
                        ExamView(vm: .init(examData: examData, examType: .forceQuitPractice))
                            .environment(examListNavigationData)
                            .navigationTitle("시험 보기")
                    default:
                        EmptyView()
                    }
                }
        }
    }
}

#Preview {
    LinuxMasterMainView()
}
