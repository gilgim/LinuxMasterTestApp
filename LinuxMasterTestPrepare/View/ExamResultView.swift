//
//  ExamResultView.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 3/5/25.
//

import SwiftUI

struct ExamResultView: View {
    var body: some View {
        VStack(spacing: 20) {
            // 헤더 영역
            Text("시험 결과")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // 틀린 문제 카드
            VStack(alignment: .leading, spacing: 8) {
                Text("이전에 맞췄는데 틀린 문제")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("1, 10, 20")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // 과목별 결과 카드
            VStack(spacing: 15) {
                subjectResultRow(subject: "1과목", score: 40, passingScore: 60)
                subjectResultRow(subject: "2과목", score: 80, passingScore: 60)
                subjectResultRow(subject: "3과목", score: 68, passingScore: 60)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // 평균 결과 카드
            VStack(spacing: 8) {
                Text("평균")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("74 / 60")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    /// 과목별 결과 행을 반환하는 함수
    private func subjectResultRow(subject: String, score: Int, passingScore: Int) -> some View {
        HStack {
            Text(subject)
                .font(.headline)
                .frame(width: 80, alignment: .leading)
            Spacer()
            Text("\(score) / \(passingScore)")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(score >= passingScore ? .green : .red)
            Image(systemName: score >= passingScore ? "checkmark.seal.fill" : "xmark.seal.fill")
                .foregroundColor(score >= passingScore ? .green : .red)
        }
    }
}

#Preview {
    ExamResultView()
        .environment(NavigationData())
}
