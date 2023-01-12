//
//  Color.swift
//  Routine
//
//  Created by 김도현 on 2023/01/10.
//

import UIKit

extension UIColor {
    static let mainColor: UIColor = UIColor(hex: 0x7BC5AE)
    static let secondaryColor: UIColor = UIColor(hex: 0xD9D9D9)
    
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
