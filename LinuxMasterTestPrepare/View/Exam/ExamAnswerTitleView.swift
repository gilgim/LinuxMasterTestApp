//
//  ExamAnswerTitleView.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 3/12/25.
//

import SwiftUI

struct ExamAnswerTitleView: View {
    @Environment(ExamViewModel.self) var vm: ExamViewModel
    let questionNumber: Int
    let questionData: Question
    var body: some View {
        // 문제 텍스트
        Text("\(questionNumber + 1).  \(questionData.question)")
            .font(.title3)
            .bold()
            .padding(.bottom, 12)
            .multilineTextAlignment(.leading)
        
        // 문제 이미지 (있는 경우)
        if let imageName = questionData.image,
           let image = Util.convertGifToJpg(fileName: imageName),
           let uiImage = UIImage(data: image) {
            HStack {
                Spacer()
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 280)
                    .cornerRadius(12)
                    .padding(.bottom, 12)
                Spacer()
            }
        }
    }
}
