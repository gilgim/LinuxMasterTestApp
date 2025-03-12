//
//  LinuxMasterTestPrepareApp.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import SwiftUI
import SwiftData

@main
struct LinuxMasterTestPrepareApp: App {
    var body: some Scene {
        WindowGroup {
            LinuxMasterMainView()
                .modelContainer(SwiftDataManager.container)
        }
    }
}
