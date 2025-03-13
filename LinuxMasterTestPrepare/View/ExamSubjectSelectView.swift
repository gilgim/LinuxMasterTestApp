//
//  ExamSubjectSelectView.swift
//  LinuxMasterTestPrepare
//
//  Created by gilgim on 3/1/25.
//

import SwiftUI

struct ExamSubjectSelectView: View {
    @Environment(NavigationData.self) var navigationData
    @Environment(\.dismiss) var dismiss
    @State var vm: ExamSubjectSelectViewModel
    
    init(vm: ExamSubjectSelectViewModel = .init(examName: "2015_03_14")) {
        self.vm = vm
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //  과목별 정보
            HStack {
                ForEach(SubjectType.allCases, id: \.self) { subject in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(subject.rawValue)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        HStack {
                            MetricView(title: "오답률", value: "0%")
                            MetricView(title: "정답률", value: "0%")
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
            }
            
            // 과목 선택 영역
            VStack(alignment: .leading, spacing: 6) {
                Text("과목 선택")
                    .font(.headline)
                ForEach(SubjectType.allCases, id: \.self) { subject in
                    HStack {
                        HStack {
                            Image(systemName: vm.selectSubject(type: subject) ? "checkmark.square.fill" : "square")
                                .resizable()
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .purple)
                                .frame(width: 20, height: 20)
                            Text(subject.rawValue)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(vm.selectSubject(type: subject) ? Color.purple.opacity(0.24) : Color.black.opacity(0.12))
                        .clipShape(.buttonBorder)
                        Spacer()
                    }
                    .onTapGesture {
                        vm.checkSubject(type: subject)
                    }
                }
            }
            .padding(.top, 24)
            
            // 이전 시험 영역
            Text("이전 시험")
                .font(.headline)
                .padding(.top, 24)
            if vm.checkPrevioseTest() {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(vm.previousExamData(), id: \.self) { exam in
                            Button(action: {
                                dismiss()
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
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "pencil.and.scribble")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                    Text("진행 중인 시험이 없습니다.\n시험을 중단한 경우라면 다시 진행할 수 있습니다.")
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(12)
                .padding(.top, 12)
            }
            
            // 강제종료 시험 영역
            Text("마저풀기")
                .font(.headline)
                .padding(.top, 32)
            if vm.checkForceQuitTest() {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(vm.forceQuitExamData(), id: \.self) { exam in
                            Button(action: {
                                dismiss()
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
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.gray)
                    Text("강제 종료된 시험이 없습니다.\n강제 종료된 시험이 있을 경우 다시 진행할 수 있습니다.")
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(12)
                .padding(.top, 20)
            }
            Spacer()
            // 액션 버튼 영역
            HStack(spacing: 16) {
                Button(action: {
                    dismiss()
                    navigationData.path.append(NavigationPathKey.exam(examName: vm.examName, examType: .practice, subjectType: vm.selectSubjects))
                }) {
                    Text("문제풀기")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(.white)
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 3)
                            }
                        )
                        .foregroundColor(Color.purple)
                }
                
                Button(action: {
                    dismiss()
                    navigationData.path.append(NavigationPathKey.exam(examName: vm.examName, examType: .test, subjectType: vm.selectSubjects))
                }) {
                    Text("시험보기")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.purple)
                        )
                        .foregroundColor(Color.white)
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        ExamSubjectSelectView()
            .environment(NavigationData())
    }
}
