//
//  UITextField.swift
//  Routine
//
//  Created by 김도현 on 2023/03/24.
//

import UIKit

class DatePickerTextField: UITextField {
    
    var datePickerSeletor: Selector?
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    override func buildMenu(with builder: UIMenuBuilder) {
        builder.remove(menu: .lookup)
    }
    
//    func addInputAccessoryView() {
//        let width = UIScreen.main.bounds.width
//        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 44.0))
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datePickerDone))
//        switch datePickerState {
//        case .start:
//            toolBar.setItems([flexible, barButton], animated: false)
//        case .end:
//            let noSettingButton = UIBarButtonItem(title: "설정안함", style: .plain, target: self, action: #selector(<#T##@objc method#>))
//        }
//        self.inputAccessoryView = toolBar
//        
//    }
//    @objc func datePickerDone() {
//        self.resignFirstResponder()
//    }
}
