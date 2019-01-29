//
//  CRPageViewDemoController.swift
//  PagerViewController
//
//  Created by daiyazhou on 2019/1/29.
//  Copyright © 2019 daiyazhou. All rights reserved.
//

import UIKit

class CRPageViewDemoController: CRViewPagerController {
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
    }
    override func titles(for viewpager: CRViewPager) -> [String] {
        return ["1","Demo2","Demo3Demo3"]
    }
    override func options(for viewpager: CRViewPager) -> [CRViewPagerIndecatorBarOption]? {
        let pagesOptions:[CRViewPagerIndecatorBarOption] = [
            .height(29),
            .backgroudColor(UIColor.xFFFFFF),
            .scrollStyle(.fixed),
            .barPaddingLeft(15),
            .barPaddingRight(15),
            .barItemTitleFont(UIFont.font16),
            .barItemTitleSelectedFont(UIFont.font16),
            .barItemTitleColor(UIColor.x888888),
            .barItemTitleSelectedColor(UIColor.x333333),
            .barItemWidth(90),
            .indicatorColor(UIColor.x333333),
            .indicatorHeight(3),
            .bottomlineColor(UIColor.xCCCCCC),
            .bottomlineHeight(0.5)
        ]
        return pagesOptions
    }
    override func pagers(for viewpager: CRViewPager) -> [CRPager] {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.x0099F1
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.xFF3366
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.xEBEBEB
        return [vc,vc2,vc3]
    }
    // event
    override func didScrollToPage(index:Int){
        print(index)
    }
    override func didScorllToLeftEdage(){
    }
    override func didScorllToRightEdage(){
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func pushNewTripViewController() {

    }

}


