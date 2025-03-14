//
//  MetricView.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 3/14/25.
//

import SwiftUI

struct MetricView: View {
    let title: String
    let value: String
    let activeColor: Color
    init(title: String, value: String, activeColor: Color = .black) {
        self.title = title
        self.value = value
        self.activeColor = activeColor
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(activeColor.opacity(0.38))
            Text(value)
                .font(.subheadline)
                .foregroundColor(activeColor.opacity(0.87))
                .lineLimit(99)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    MetricView(title: "타이틀", value: "값")
}
