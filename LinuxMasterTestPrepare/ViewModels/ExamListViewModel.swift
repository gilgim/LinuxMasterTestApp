//
//  ExamListViewModel.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//

import Foundation

@Observable
class ExamListViewModel {
    func listName() -> [String] {
        return Util.getJSONFileNames().map {$0.replacingOccurrences(of: ".json", with: "")}.sorted(by: {$0 > $1})
    }
}
