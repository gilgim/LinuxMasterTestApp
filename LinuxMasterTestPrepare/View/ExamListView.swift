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
                        VStack(alignment: .leading, spacing: 8) {
                            Text(name)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 16) {
                                MetricView(title: "오답률", value: "0%")
                                MetricView(title: "정답률", value: "0%")
                                MetricView(title: "시험 횟수", value: "0회")
                                MetricView(title: "연습 횟수", value: "0회")
                            }
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
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer().frame(height: 32)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .onChange(of: selectName, { oldValue, newValue in
            if oldValue != newValue {
                self.isSheet.toggle()
            }
        })
        .sheet(isPresented: $isSheet) {
            NavigationStack {
                ExamSubjectSelectView(vm: .init(examName: selectName))
                    .environment(navigationData)
                    .navigationTitle(selectName)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct MetricView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    ExamListView()
        .environment(NavigationData())
}
