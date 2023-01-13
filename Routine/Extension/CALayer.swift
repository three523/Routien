//
//  CALayer.swift
//  Routine
//
//  Created by 김도현 on 2023/01/11.
//

import UIKit

extension CALayer {
    func addBorder(_ edges: [UIRectEdge], color: UIColor, size: CGSize, width: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: size.width, height: width)
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: size.height - width, width: size.width, height: width)
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: size.height)
            case UIRectEdge.right:
                border.frame = CGRect.init(x: size.width - width, y: 0, width: width, height: size.height)
            default:
                return
            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
