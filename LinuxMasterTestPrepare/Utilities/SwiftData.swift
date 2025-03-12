//
//  SwiftData.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 3/5/25.
//

import SwiftData
import Foundation

protocol SwiftDataModel { var id: UUID { get set } }
class SwiftDataManager {
    @MainActor static let container: ModelContainer = {
        let isUsePreview: Bool = true
        let schema = Schema([ExamData.self])
        let configuration = isUsePreview
            ? ModelConfiguration(isStoredInMemoryOnly: true)
            : ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("❌ ModelContainer 생성 실패: \(error)")
        }
    }()
    
    // MARK: - Create
    @MainActor
    static func create<T: PersistentModel>(_ object: T) throws {
        do {
            Self.container.mainContext.insert(object)
            try Self.container.mainContext.save()
            print("데이터 저장 성공: \(object)")
        } catch {
            print("데이터 저장 실패: \(error)")
            throw error
        }
    }
    
    // MARK: - Read
    @MainActor
    static func fetchAll<T: PersistentModel>(ofType type: T.Type) throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        do {
            let result = try Self.container.mainContext.fetch(descriptor)
            print("데이터 불러오기 성공: \(result)")
            return result
        } catch {
            print("데이터 불러오기 실패: \(error)")
            throw error
        }
    }
    
    // MARK: - Update
    @MainActor
    static func update<T: PersistentModel>(_ object: T) throws {
        var allData = try? Self.fetchAll(ofType: T.self)
        if let idx = allData?.firstIndex(where: { $0.id == object.id }) {
            allData?[idx] = object
            try Self.container.mainContext.save()
            print("데이터 업데이트 성공: \(object)")
        } else {
            print("데이터 없음, 업데이트 실패")
        }
    }
    
    // MARK: - Delete
    @MainActor
    static func delete<T: PersistentModel>(_ object: T) throws {
        do {
            Self.container.mainContext.delete(object)
            try Self.container.mainContext.save()
            print("데이터 삭제 성공: \(object)")
        } catch {
            print("데이터 삭제 실패: \(error)")
            throw error
        }
    }
}
