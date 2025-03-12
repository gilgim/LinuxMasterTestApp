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
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(vm.listName(), id: \.self) { name in
                    HStack {
                        Spacer()
                        VStack {
                            Text(name)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 32)
                    .background(Color.black.opacity(0.12))
                    .clipShape(.buttonBorder)
                    .onTapGesture {
                        navigationData.path.append(NavigationPathKey.subjectSelect(examName: name))
                    }
                }
                Spacer().frame(height: 68)
            }
            .padding(.horizontal, 24)
        }
    }
}
#Preview {
    ExamListView()
        .environment(NavigationData())
}
