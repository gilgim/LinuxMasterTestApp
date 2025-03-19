//
//  ColorExtension.swift
//  LinuxMasterTestPrepare
//
//  Created by gaea on 3/19/25.
//

import SwiftUI
import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cleanedHex.hasPrefix("#") {
            cleanedHex.removeFirst()
        }
        
        guard cleanedHex.count == 3 || cleanedHex.count == 6 || cleanedHex.count == 8 else {
            return nil
        }
        
        if cleanedHex.count == 3 {
            cleanedHex = cleanedHex.map { "\($0)\($0)" }.joined()
        }
        
        if cleanedHex.count == 6 {
            cleanedHex.append("FF") // Alpha 값 추가 (기본값: 255)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat(rgbValue & 0x000000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension Color {
    init(hex: String) {
        if let uiColor = UIColor(hex: hex) {
            self.init(uiColor)
        } else {
            self.init(white: 0.5) // 기본 색상 (중간 회색)
        }
    }
    static let cornFlowerBlue: Color = .init(hex: "6395EE")
}
