//
//  CustomAnimation.swift
//  Contacts
//
//  Created by Vamsi Krishna on 17/08/22.
//

import Foundation
import UIKit

class CustomAnimation {
    
    static func animateTextField(textField: UITextField){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 1
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x, y: textField.center.y - 100))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x, y: textField.center.y + 100))
        textField.layer.add(animation, forKey: "position")

        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemYellow])
    }
    
    static func animateButton(button: UIButton){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 1
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: button.center.x, y: button.center.y - 100))
        animation.toValue = NSValue(cgPoint: CGPoint(x: button.center.x, y: button.center.y + 100))
        button.layer.add(animation, forKey: "position")
    }
    
    static func animateLabels(label: UILabel){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 1
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: label.center.x, y: label.center.y - 100))
        animation.toValue = NSValue(cgPoint: CGPoint(x: label.center.x, y: label.center.y + 100))
        label.layer.add(animation, forKey: "position")
    }
}
