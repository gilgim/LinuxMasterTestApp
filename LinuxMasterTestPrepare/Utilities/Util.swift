//
//  Util.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 2/28/25.
//
import UIKit
import ImageIO

class Util {
    /// 운동명 수정
    static func examNameFormatting(_ examName: String) -> String {
        let components = examName.split(separator: "_").map { String($0) }
        guard components.count >= 3 else { return examName }
        return "\(components[0])년 \(components[1])월 \(components[2])일 회차"
    }
    /// Find All Json File
    static func getJSONFileNames(subdirectory: String? = nil) -> [String] {
        guard let jsonURLs = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: subdirectory) else {
            return []
        }
        // 파일 이름만 추출 (확장자 포함)
        return jsonURLs.map { $0.lastPathComponent }
    }
    /// Json Parsing
    static func parseJSON<T: Decodable>(fromFile fileName: String, to type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        // 파일 이름을 기반으로 JSON 데이터 로드
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("❌ 파일을 찾을 수 없음: \(fileName).json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            print("❌ JSON 파싱 실패: \(error)")
            return nil
        }
    }
    static func parseJSON<T: Decodable>(data: Data, to type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            print("❌ JSON 파싱 실패: \(error)")
            return nil
        }
    }
    /// Json Encoding
    static func encodeJSON<T: Encodable>(from object: T) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys] // 가독성을 위해 옵션 설정 (선택사항)
        
        do {
            let data = try encoder.encode(object)
            return data
        } catch {
            print("❌ JSON 인코딩 실패: \(error)")
            return nil
        }
    }
    /// GIF -> JPG
    static func convertGifToJpg(fileName: String) -> Data? {
        // 파일명에서 ".gif" 확장자를 제거
        let editFileName = fileName.replacingOccurrences(of: ".gif", with: "")

        // Bundle에서 GIF 파일 URL 가져오기
        guard let fileURL = Bundle.main.url(forResource: editFileName, withExtension: "gif"),
              let gifData = try? Data(contentsOf: fileURL) else {
            print("❌ GIF 파일 로드 실패: \(editFileName).gif")
            return nil
        }

        // GIF 데이터를 기반으로 이미지 소스 생성
        guard let imageSource = CGImageSourceCreateWithData(gifData as CFData, nil) else {
            print("❌ 이미지 소스 생성 실패")
            return nil
        }

        // 첫 번째 프레임 추출 (GIF의 첫 번째 이미지 가져오기)
        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            print("❌ 첫 번째 프레임 추출 실패")
            return nil
        }

        // UIImage로 변환
        let image = UIImage(cgImage: cgImage)

        // JPEG 데이터로 변환 (압축 품질 1.0: 최고 품질)
        return image.jpegData(compressionQuality: 1.0)
    }
}
