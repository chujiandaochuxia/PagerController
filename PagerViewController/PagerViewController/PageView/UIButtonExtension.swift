//
//  UIButtonExtension.swift
//  PagerViewController
//
//  Created by daiyazhou on 2019/1/29.
//  Copyright © 2019 daiyazhou. All rights reserved.
//

import UIKit

extension UIButton {
    func setTitle(title: String?) {
        self.setTitle(title, for: .normal)
    }
    
    func setBgColor(bgColorNormal: UIColor) {
        self.setBgColor(backgroundColor: bgColorNormal, forState: .normal)
    }
    
    func setBgColor(bgColorNormal: UIColor, bgColorPressed: UIColor) {
        self.setBgColor(backgroundColor: bgColorNormal, forState: .normal)
        let image = UIImage.createImageWithColor(bgColorPressed)
        self.setBackgroundImage(image, for: .selected)
        self.setBackgroundImage(image, for: .highlighted)
    }
    
    func setBgColor(backgroundColor:UIColor, forState state:UIControl.State) {
        self.setBackgroundImage(UIImage.createImageWithColor(backgroundColor), for: state)
    }
    
    func setTitleFont(font: UIFont?) {
        self.titleLabel?.font = font
    }
    
    func setTitleColor(color: UIColor?) {
        self.setTitleColor(color, for: .normal)
    }
    func setImage(image: UIImage?) {
        self.setImage(image, for: UIControl.State.normal)
    }

}
