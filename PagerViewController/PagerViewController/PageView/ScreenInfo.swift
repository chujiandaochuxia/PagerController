//
//  ScreenInfo.swift
//  PagerViewController
//
//  Created by daiyazhou on 2019/1/29.
//  Copyright © 2019 daiyazhou. All rights reserved.
//

import UIKit

struct ScreenInfo {
    static let Frame = UIScreen.main.bounds
    static let Height = Frame.height
    static let Width = Frame.width
    static let Scale = Width / 375
    static let HeightScale = Height / 667
    static let StatusBarHeght: CGFloat = statusBarHeight()
    static let bottomBarHeight:CGFloat = 60
    static let bottomBarAlpha:CGFloat = 0.98
    static let navigationHeight:CGFloat = navBarHeight()
    static let tabBarHeight:CGFloat = tabBarrHeight()
    static let Kmargin_15:CGFloat = 15
    static let Kmargin_10:CGFloat = 10
    static let Kmargin_5:CGFloat = 5
    static func getBorderWidth(_ width:CGFloat) -> CGFloat {
        return width / UIScreen.main.scale * 2
    }
    static func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812)) || UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 414, height: 896))
    }
    static private func navBarHeight() -> CGFloat {
        return isIphoneX() ? 88 : 64;
    }
    static private func tabBarrHeight() -> CGFloat {
        return isIphoneX() ? 83 : 49;
    }
    static private func statusBarHeight() -> CGFloat{
        return isIphoneX() ? 44 : 20
    }
    
}
