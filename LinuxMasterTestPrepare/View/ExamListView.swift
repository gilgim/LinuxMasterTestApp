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
                        HStack(spacing: 16) {
                            MetricView(title: "오답률", value: "0%")
                            MetricView(title: "정답률", value: "0%")
                            MetricView(title: "시험 횟수", value: "0회")
                            MetricView(title: "연습 횟수", value: "0회")
                        }
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
