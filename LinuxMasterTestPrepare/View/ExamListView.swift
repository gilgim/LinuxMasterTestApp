//
//  ExamListView.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import SwiftUI

struct ExamListView: View {
    @Environment(NavigationData.self) var navigationData
    @State var vm = ExamListViewModel()
    @State var isSheet: Bool = false
    @State var selectName: String = ""
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(vm.listName(), id: \.self) { name in
                    Button(action: {
                        self.selectName = name
                    }) {
                        Text(Util.examNameFormatting(name))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        ExamDetailView(examName: name)
                            .environment(vm)
                    }
                    .buttonStyle(ExamListViewStyle())
                }
                Spacer().frame(height: 32)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .onChange(of: selectName, { oldValue, newValue in
            guard newValue != "" else {return}
            if oldValue != newValue {
                self.isSheet.toggle()
            }
        })
        .sheet(isPresented: $isSheet, onDismiss: { self.selectName = "" }) {
            NavigationStack {
                ExamSubjectSelectView(vm: .init(examName: selectName))
                    .environment(navigationData)
                    .navigationTitle(Util.examNameFormatting(selectName))
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    struct ExamDetailView: View {
        @Environment(ExamListViewModel.self) var vm
        @State var examIncorrectRate: String = "-"
        @State var examCorrectRate: String = "-"
        @State var examTestCount: String = "-"
        @State var examPracticeCount: String = "-"
        let examName: String
        var body: some View {
            HStack(spacing: 16) {
                MetricView(title: "오답률", value: examIncorrectRate)
                MetricView(title: "정답률", value: examCorrectRate)
                MetricView(title: "시험 횟수", value: examTestCount)
                MetricView(title: "연습 횟수", value: examPracticeCount)
            }
            .onAppear() {
                Task { @MainActor in
                    if let examIncorrectRate = await vm.examIncorrectRate(examName: examName) {
                        self.examIncorrectRate = "\(examIncorrectRate)%"
                    }
                    if let examCorrectRate = await vm.examCorrectRate(examName: examName) {
                        self.examCorrectRate = "\(examCorrectRate)%"
                    }
                    if let examTestCount = await vm.examTestCount(examName: examName) {
                        self.examTestCount = "\(examTestCount)회"
                    }
                    if let examPracticeCount = await vm.examPracticeCount(examName: examName) {
                        self.examPracticeCount = "\(examPracticeCount)회"
                    }
                }
            }
        }
    }
    struct ExamListViewStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                configuration.label
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(UIColor.separator), lineWidth: 1)
            )
        }
    }
}

#Preview {
    ExamListView()
        .environment(NavigationData())
}
