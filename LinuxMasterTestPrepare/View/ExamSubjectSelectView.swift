//
//  ExamSubjectSelectView.swift
//  LinuxMasterTestPrepare
//
//  Created by gilgim on 3/1/25.
//

import SwiftUI

struct ExamSubjectSelectView: View {
    @Environment(NavigationData.self) var navigationData
    @State var vm: ExamSubjectSelectViewModel
    
    init(vm: ExamSubjectSelectViewModel = .init(examName: "2015_03_14")) {
        self.vm = vm
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // 제목 및 시험 이름
            Text(vm.examName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 24)
            
            // 과목 선택 영역
            VStack(alignment: .leading, spacing: 16) {
                Text("과목 선택")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(SubjectType.allCases, id: \.self) { subject in
                            Text(subject.rawValue)
                                .fontWeight(.medium)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(vm.selectSubject(type: subject)
                                                ? Color.blue.opacity(0.8)
                                                : Color.gray.opacity(0.1))
                                )
                                .foregroundColor(vm.selectSubject(type: subject) ? .white : .primary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(vm.selectSubject(type: subject)
                                                    ? Color.blue.opacity(0.8)
                                                    : Color.clear, lineWidth: 1)
                                )
                                .shadow(color: vm.selectSubject(type: subject)
                                            ? Color.blue.opacity(0.3)
                                            : Color.clear, radius: 4, x: 0, y: 2)
                                .onTapGesture {
                                    withAnimation {
                                        vm.checkSubject(type: subject)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // 이전 시험 영역
            if vm.checkPrevioseTest() {
                VStack(alignment: .leading, spacing: 12) {
                    Text("이전 시험")
                        .font(.headline)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(vm.previousExamData(), id: \.self) { exam in
                                Button(action: {
                                    navigationData.path.append(NavigationPathKey.previousExam(examData: exam))
                                }) {
                                    VStack(spacing: 8) {
                                        Text(exam.examName)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Text("이전 문제 풀기")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.blue)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.blue, lineWidth: 1)
                                            )
                                    }
                                    .padding()
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            // 강제종료 시험 영역
            if vm.checkForceQuitTest() {
                VStack(alignment: .leading, spacing: 12) {
                    Text("마저 풀기")
                        .font(.headline)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(vm.forceQuitExamData(), id: \.self) { exam in
                                Button(action: {
                                    navigationData.path.append(NavigationPathKey.forceQuitExam(examData: exam))
                                }) {
                                    VStack(spacing: 8) {
                                        Text(exam.examName)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Text("마저 풀기")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.red)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.red, lineWidth: 1)
                                            )
                                    }
                                    .padding()
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            // 액션 버튼 영역
            HStack(spacing: 16) {
                Button(action: {
                    navigationData.path.append(NavigationPathKey.exam(examName: vm.examName, examType: .practice, subjectType: vm.selectSubjects))
                }) {
                    Text("문제풀기")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                }
                
                Button(action: {
                    navigationData.path.append(NavigationPathKey.exam(examName: vm.examName, examType: .test, subjectType: vm.selectSubjects))
                }) {
                    Text("시험보기")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.vertical)
    }
}

#Preview {
    ExamSubjectSelectView()
        .environment(NavigationData())
}
