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
            Text("과목 선택")
                .font(.headline)
            HStack {
                ForEach(SubjectType.allCases, id: \.self) { subject in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(subject.rawValue)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        HStack {
                            MetricView(title: "오답률", value: vm.subjectIncorrectRate(subjectType: subject))
                            MetricView(title: "정답률", value: vm.subjectCorrectRate(subjectType: subject))
                        }
                    }
                    .modifier(ExamInfoComponentStyle(vm.selectSubject(type: subject) ? .accentColor : .black, alignment: .leading))
                    .onTapGesture {
                        vm.checkSubject(type: subject)
                    }
                }
            }
            .padding(.top, 12)
            // 이전 시험 영역
            Text("이전 시험")
                .font(.headline)
                .padding(.top, 24)
            if vm.checkPrevioseTest() {
                StoppedExamView(dismiss: _dismiss, accentColor: .accentColor)
                    .environment(vm)
                    .environment(navigationData)
                    .padding(.top, 12)
            } else {
                Text("진행 중인 시험이 없습니다.\n시험을 중단한 경우라면 다시 진행할 수 있습니다.")
                    .modifier(ExamEmptyViewStyle(systemName: "pencil.and.scribble"))
            }
            // 강제종료 시험 영역
            Text("마저풀기")
                .font(.headline)
                .padding(.top, 32)
            if vm.checkForceQuitTest() {
                ForceStoppedExamView(dismiss: _dismiss, accentColor: .red)
                    .environment(vm)
                    .environment(navigationData)
                    .padding(.top, 12)
            } else {
                Text("강제 종료된 시험이 없습니다.\n강제 종료된 시험이 있을 경우 다시 진행할 수 있습니다.")
                    .modifier(ExamEmptyViewStyle(systemName: "xmark.circle"))
            }
            Spacer()
            // 액션 버튼 영역
            HStack(spacing: 16) {
                Button(action: {
                    dismiss()
                    navigationData.path.append(NavigationPathKey.exam(examName: vm.examName, examType: .practice, subjectType: vm.selectSubjects))
                }) {
                    Text("문제풀기")
                }
                .buttonStyle(ExamButtonStyle(fillButton: false))
                
                Button(action: {
                    dismiss()
                    navigationData.path.append(NavigationPathKey.exam(examName: vm.examName, examType: .test, subjectType: vm.selectSubjects))
                }) {
                    Text("시험보기")
                }
                .buttonStyle(ExamButtonStyle(fillButton: true))
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 16)
    }
    //  MARK: View & Style
    //  과목 선택 요소
    struct SelectSubjectView: View {
        @Environment(ExamSubjectSelectViewModel.self) var vm
        let subject: SubjectType
        var body: some View {
            HStack {
                Image(systemName: vm.selectSubject(type: subject) ? "checkmark.square.fill" : "square")
                    .resizable()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.white, Color.accentColor)
                    .frame(width: 20, height: 20)
                Text(subject.rawValue)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(vm.selectSubject(type: subject) ? Color.accentColor : Color.black.opacity(0.12))
            .clipShape(.buttonBorder)
        }
    }
    //  이전 진행 중인 시험 목록
    struct StoppedExamView: View {
        @Environment(NavigationData.self) var navigationData
        @Environment(\.dismiss) var dismiss
        @Environment(ExamSubjectSelectViewModel.self) var vm
        let accentColor: Color
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.previousExamData(), id: \.self) { exam in
                        Button(action: {
                            dismiss()
                            navigationData.path.append(NavigationPathKey.previousExam(examData: exam))
                        }) {
                            VStack(alignment: .center, spacing: 8) {
                                Text(Util.examNameFormatting(exam.examName))
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(accentColor.opacity(0.87))
                                HStack(alignment: .top) {
                                    MetricView(title: "날짜", value: "2025년 11월 25일\n2시 24분", activeColor: accentColor)
                                    MetricView(title: "진행률", value: "0%", activeColor: accentColor)
                                }
                            }
                            .modifier(ExamSubjectSelectView.ExamInfoComponentStyle(accentColor, alignment: .center))
                            .frame(width: 200)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    //  강제 종료된 시험 목록
    struct ForceStoppedExamView: View {
        @Environment(NavigationData.self) var navigationData
        @Environment(\.dismiss) var dismiss
        @Environment(ExamSubjectSelectViewModel.self) var vm
        let accentColor: Color
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.forceQuitExamData(), id: \.self) { exam in
                        Button(action: {
                            dismiss()
                            navigationData.path.append(NavigationPathKey.forceQuitExam(examData: exam))
                        }) {
                            VStack(alignment: .center, spacing: 8) {
                                Text(Util.examNameFormatting(exam.examName))
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(accentColor.opacity(0.87))
                                HStack(alignment: .top) {
                                    MetricView(title: "날짜", value: "2025년 11월 25일\n2시 24분", activeColor: accentColor)
                                    MetricView(title: "진행률", value: "0%", activeColor: accentColor)
                                }
                            }
                            .modifier(ExamSubjectSelectView.ExamInfoComponentStyle(accentColor, alignment: .center))
                            .frame(width: 150)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    //  정보 노출 뷰 스타일
    struct ExamInfoComponentStyle: ViewModifier {
        let activeColor: Color
        let alignment: Alignment
        init(_ activeColor: Color = .black, alignment: Alignment) {
            self.activeColor = activeColor
            self.alignment = alignment
        }
        func body(content: Content) -> some View {
            content
                .padding()
                .frame(maxWidth: .infinity, alignment: alignment)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(activeColor.opacity(0.2))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(activeColor.opacity(0.35), lineWidth: 1)
                )
        }
    }
    //  빈화면 스타일
    struct ExamEmptyViewStyle: ViewModifier {
        let systemName: String
        func body(content: Content) -> some View {
            HStack(spacing: 8) {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.gray)
                content
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.tertiarySystemBackground))
            .cornerRadius(12)
            .padding(.top, 20)
            .padding(.leading, 48)
        }
    }
    //  하단 버튼 스타일
    struct ExamButtonStyle: ButtonStyle {
        let fillButton: Bool
        func makeBody(configuration: Configuration) -> some View {
            if fillButton {
                configuration.label
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.accentColor)
                    )
                    .foregroundColor(Color.white)
            } else {
                configuration.label
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
                    .foregroundColor(Color.accentColor)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExamSubjectSelectView()
            .environment(NavigationData())
    }
}
