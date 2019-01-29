//
//  UIImageExtension.swift
//  PagerViewController
//
//  Created by daiyazhou on 2019/1/29.
//  Copyright © 2019 daiyazhou. All rights reserved.
//

import UIKit

extension UIImage {
    //根据颜色生成图片
    class func createImageWithColor(_ color : UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect);
        let theImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return theImage
    }
}
