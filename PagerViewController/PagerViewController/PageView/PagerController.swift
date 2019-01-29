//
//  PagerController.swift
//  PagerViewController
//
//  Created by daiyazhou on 2019/1/29.
//  Copyright © 2019 daiyazhou. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ViewPager Container titleBar ScrollStyle
public enum CRViewPagerTitleBarScrollStyle{
//    case scroll
    case fixed
}
// MARK: - ViewPager Show Options
public enum CRViewPagerIndecatorBarOption {
    case height(CGFloat)
    case backgroudColor(UIColor)
    case scrollStyle(CRViewPagerTitleBarScrollStyle)  // 每一个 barItem 是固定的还是可以滚动
    case barPaddingLeft(CGFloat)
    case barPaddingRight(CGFloat)
    case barPaddingTop(CGFloat)
    case barItemTitleFont(UIFont)
    case barItemTitleSelectedFont(UIFont)
    case barItemTitleColor(UIColor)
    case barItemTitleSelectedColor(UIColor)
    case barItemWidth(CGFloat)
    case indicatorColor(UIColor)
    case indicatorHeight(CGFloat)
    case indicatorBottom(CGFloat)
    case bottomlineColor(UIColor)
    case bottomlineHeight(CGFloat)
    case bottomlinePaddingLeft(CGFloat)
    case bottomlinePaddingRight(CGFloat)
}

// MARK: - Scroll view delegate
fileprivate class InnderScrollViewDelegate: NSObject, UIScrollViewDelegate{
    weak var scrollerView:UIScrollView?
    var startLeft: CGFloat = 0.0
    var startRight: CGFloat = 0.0
    var whenScrollToLeftEdage: (()->())?
    var whenScrollToRightEdage: (()->())?
    var whenScrollToPageIndex: ((_ index:Int)->())?
    var whenScrollPercent: ((_ percent:CGFloat)->())?
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.scrollerView === scrollView {
            startLeft = scrollView.contentOffset.x
            startRight = scrollView.contentOffset.x + scrollView.frame.size.width;
        }else {
            print("newscrollView")
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.scrollerView === scrollView {
            self.whenScrollToPageIndex?(Int(scrollView.contentOffset.x/scrollView.frame.size.width))
        }
    }
    //    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //        if self.scrollerView === scrollView {
    //            self.whenScrollToPageIndex?(Int(targetContentOffset.pointee.x/scrollView.frame.width))
    //        }
    //    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollerView === scrollView {
            self.whenScrollPercent?(scrollView.contentOffset.x)
            let bottomEdge = scrollView.contentOffset.x + scrollView.frame.size.width;
            if (bottomEdge >= scrollView.contentSize.width && bottomEdge == startRight) {
                self.whenScrollToLeftEdage?()
            }
            if (scrollView.contentOffset.x == 0 && startLeft == 0) {
                self.whenScrollToRightEdage?()
            }
        }else {
            print("newscrollView")
        }
    }
}
// MARK: -  CRViewPagerDelegate
protocol CRViewPagerDelegate: class{
    //init
    func titles(`for` viewpager: CRViewPager)->[String]
    func options(`for` viewpager: CRViewPager)->[CRViewPagerIndecatorBarOption]?
    func pagers(`for` viewpager: CRViewPager)->[CRPager]
    // event
    func didScrollToPage(index: Int)
    // 向左滚动(percent<0)或者向右滚动(percent>0)占应该滚动百分比
    func didScroll(percent: CGFloat)
    func didScorllToLeftEdage()
    func didScorllToRightEdage()
}

// MARK: -  CRViewPagerDelegate
protocol CRViewPagerIndeicatorBarDelegate : class{
    func didClickedIndicatorItem(index: Int)
}

typealias CRPager = UIViewController

class CRViewPager: UIScrollView{
    
    private var _pagers = [CRPager]()
    
    var pagers: [CRPager]{
        get{
            return _pagers
        }
    }
    
    func setup(with pagers: [CRPager] ){
        _pagers = pagers
        self.contentSize = CGSize(width: CGFloat(pagers.count)*(self.frame.width), height: (self.frame.height))
        for i in 0..<pagers.count{
            let viewPage = pagers[i]
            viewPage.view.frame = CGRect(x: CGFloat(i)*self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
        }
    }
    func scrollToPage(index: Int,animation:Bool = true) {
        guard index < pagers.count else {
            return
        }
        if animation{
            UIView.animate(withDuration: 0.2) {
                self.contentOffset = CGPoint(x: CGFloat(index)*self.pagers[index].view.frame.size.width, y: 0)
            }
        }else {
            self.contentOffset = CGPoint(x: CGFloat(index)*self.pagers[index].view.frame.size.width, y: 0)
        }
    }
}


class  CRViewPagerIndeicator: UIButton{
    
}

class CRViewPagerIndeicatorBarButtomItem: UIButton{
    
}

class CRViewPagerIndeicatorBar: UIView{
    fileprivate weak var delegate: CRViewPagerIndeicatorBarDelegate?
    
    private let contentView = UIScrollView()
    
    //滑块
    private let indicatorContainer = UIView();
    private let indicator = UIView()
    private var indicatorColor = UIColor.gray
    private var indicatorTitles = [String]()
    private var indicatorBackgroudColor = UIColor.white
    private var indicatorHeight:CGFloat = 8.0
    private var indicatorBottom:CGFloat = 0.0
    ///Bar底部线
    private let bottomline = UIView();
    private var bottomlineColor  = UIColor.blue
    private var bottomlineHeight: CGFloat = 5.0
    private var bottomlinePaddingLeft: CGFloat = 0.0
    private var bottomlinePaddingRight: CGFloat = 0.0
    
    //Bar本身属性
    private var barHeight: CGFloat = 50.0
    private var paddingLeft: CGFloat = 0.0
    private var paddingRight: CGFloat = 0.0
    private var paddingTop: CGFloat = 0.0
    ///barItem 是可以滚动的，还是固定的
    private var scrollStyle = CRViewPagerTitleBarScrollStyle.fixed
    //barItem
    private var barItemTitleFont = UIFont.systemFont(ofSize: 17)
    private var barItemTitleSelectedFont = UIFont.systemFont(ofSize: 17)
    private var barItemWidth: CGFloat = 100.0
    private var barItemTitleColor = UIColor.black
    private var barItemTitleSelectedColor = UIColor.blue
    
    private var buttonItems = [CRViewPagerIndeicatorBarButtomItem]()
    private var curIndex = 0
    private var itemCount = 0
    func setup(with options: [CRViewPagerIndecatorBarOption], titles: [String]){
        parse(options: options, itemCount: Int(titles.count))
        setupUIElement(with: titles)
    }
    
    func parse(options: [CRViewPagerIndecatorBarOption],itemCount: Int){
        for option in options{
            switch (option){
            case  let .height(value):
                self.barHeight = value
            case  let .backgroudColor(value):
                self.backgroundColor = value
            case let .scrollStyle(value):
                self.scrollStyle = value
            case let .barPaddingLeft(value):
                self.paddingLeft = value
            case let .barPaddingRight(value):
                self.paddingRight = value
            case let .barPaddingTop(value):
                self.paddingTop = value
            case  let .barItemTitleFont(value):
                self.barItemTitleFont = value
            case let .barItemTitleSelectedFont(value):
                self.barItemTitleSelectedFont = value
            case  let .barItemTitleColor(value):
                self.barItemTitleColor = value
            case  let .barItemTitleSelectedColor(value):
                self.barItemTitleSelectedColor = value
            case  let .barItemWidth(value):
                self.barItemWidth = value
            case  let .indicatorColor(value):
                self.indicatorColor = value
            case let .indicatorHeight(value):
                self.indicatorHeight = value
            case let .indicatorBottom(value):
                self.indicatorBottom = value
            case  let .bottomlineColor(value):
                self.bottomlineColor = value
            case let .bottomlineHeight(value):
                self.bottomlineHeight = value
            case let .bottomlinePaddingLeft(value):
                self.bottomlinePaddingLeft = value
            case let .bottomlinePaddingRight(value):
                self.bottomlinePaddingRight = value
            }
        }
        self.itemCount = itemCount
        switch scrollStyle{
        case .fixed:
            self.barItemWidth =  (UIScreen.main.bounds.width-paddingLeft-paddingRight)/CGFloat(itemCount)
//        case .scroll: break
        }
        
    }
    func setupUIElement(with titles: [String]){
        self.addSubview(contentView)
        contentView.frame =  CGRect(x:paddingLeft, y: paddingTop, width: ScreenInfo.Width-paddingLeft-paddingRight, height: barHeight - paddingTop)
        contentView.backgroundColor = UIColor.clear
        self.frame = CGRect(x:0, y: ScreenInfo.StatusBarHeght, width: ScreenInfo.Width, height: barHeight)
        contentView.contentSize = CGSize(width: barItemWidth*CGFloat(titles.count), height: barHeight - paddingTop)
        
        for i in 0..<titles.count{
            let buttonItem = CRViewPagerIndeicatorBarButtomItem()
            buttonItem.backgroundColor = UIColor.clear
            buttonItem.titleLabel?.font = barItemTitleFont;
            buttonItem.setTitle(titles[i], for: UIControl.State.normal)
            buttonItem.titleLabel?.textAlignment = NSTextAlignment.center
            buttonItem.titleLabel?.sizeToFit()
            buttonItem.setTitleColor(barItemTitleColor, for: UIControl.State.normal)
            buttonItem.tag = i
            buttonItem.frame =  CGRect(x:CGFloat(i)*barItemWidth,y:0,width:barItemWidth,height:barHeight - paddingTop)
            buttonItem.addTarget(self, action:#selector(CRViewPagerIndeicatorBar.onClickTitle(_:)), for:.touchUpInside)
            buttonItems.append(buttonItem)
            contentView.addSubview(buttonItem)
        }
        
        bottomline.frame = CGRect(x: bottomlinePaddingLeft,
                                  y: barHeight - bottomlineHeight,
                                  width: UIScreen.main.bounds.width - bottomlinePaddingLeft - bottomlinePaddingRight,
                                  height: bottomlineHeight / UIScreen.main.scale * 2)
        bottomline.backgroundColor = bottomlineColor
        self.addSubview(bottomline)
        
        indicatorContainer.frame = CGRect(x: 0, y: barHeight - paddingTop - 6 - indicatorBottom, width: barItemWidth, height: indicatorHeight)
        indicatorContainer.addSubview(indicator)
        indicator.backgroundColor = indicatorColor
        contentView.addSubview(indicatorContainer)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @objc func onClickTitle(_ title: UIControl){
        let index = Int(title.tag)
        self.delegate?.didClickedIndicatorItem(index: index)
        scrollIndicator(to:index)
    }
    func scrollIndicator(to index: Int,animated: Bool=true){
        let rang = 0..<buttonItems.count
        guard rang.contains(Int(index)) else {
            return
        }
        var offsetX = CGFloat(index) * barItemWidth + barItemWidth/2
        offsetX = offsetX - contentView.frame.width/2
        offsetX = min(offsetX,contentView.contentSize.width - contentView.frame.width)
        offsetX = max(offsetX,0)
        contentView.setContentOffset(CGPoint(x: offsetX  , y: 0), animated: true)
        print("offsetX => \(CGFloat(index) * barItemWidth + barItemWidth/2)")
        
        let origialLabel = buttonItems[curIndex]
        origialLabel.setTitleColor(barItemTitleColor, for: UIControl.State.normal)
        origialLabel.setTitleFont(font: barItemTitleFont)
        curIndex = index;
        let curLabel = buttonItems[curIndex]
        curLabel.setTitleFont(font: barItemTitleSelectedFont)
        curLabel.setTitleColor(barItemTitleSelectedColor, for: UIControl.State.normal)
        
        UIView.animate(withDuration: animated ? 0.2 : 0 , animations: { () -> Void in
            self.indicatorContainer.frame = CGRect(x: CGFloat(index)*self.barItemWidth, y: self.barHeight - self.paddingTop - self.indicatorHeight - self.indicatorBottom, width: self.barItemWidth, height: self.indicatorHeight)
            if let titleLable = curLabel.titleLabel{
                if titleLable.frame.width != 0{
                    self.indicator.frame = CGRect(x: titleLable.frame.origin.x, y: 0, width: titleLable.frame.width, height: self.indicatorHeight)
                }
            }else {
                self.indicator.frame = self.indicatorContainer.frame
            }
        })
    }
    func scrooIndicator(to percent:CGFloat,animated: Bool=true){
        self.indicatorContainer.frame = CGRect(x: percent/CGFloat(self.itemCount), y: self.barHeight - self.paddingTop - self.indicatorHeight - self.indicatorBottom, width: self.barItemWidth, height: self.indicatorHeight)
    }
}

class CRViewPagerController: UIViewController,CRViewPagerDelegate,CRViewPagerIndeicatorBarDelegate{
    
    private var _titles = [String]()
    private var _viewpager: CRViewPager! = nil
    private var _curIndex = 0
    var autoSetupUI: Bool = true
    
    var titles: [String] {
        return _titles
    }
    
    var viewpager:CRViewPager {
        return _viewpager
    }
    var curIndex: Int{
        set(newValue){
            _curIndex = newValue
        }
        get{
            return _curIndex
        }
    }
    
    private let scrollDelegate = InnderScrollViewDelegate()
    private var indeicatorBar = CRViewPagerIndeicatorBar()
    
    private var autoScrollIndicator = true
    var scrollEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _curIndex = defaultPageIndex()
        if autoSetupUI {
            self.setupUI()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.setNeedsLayout()
    }
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.indeicatorBar.scrollIndicator(to: curIndex,animated: false)
        viewpager.scrollToPage(index: curIndex)
    }
    
    func setupUI() {
        _viewpager = CRViewPager()
        _viewpager.bounces = false
        _viewpager.isScrollEnabled = scrollEnable
        self._titles =  self.titles(for: self._viewpager)
        if let options = self.options(for: self._viewpager) {
            self.indeicatorBar.setup(with: options, titles: titles)
        }
        self.indeicatorBar.delegate = self
        self.view.addSubview(indeicatorBar)
        
        let viewPagerFrame = CGRect(x: 0,
                                    y: self.indeicatorBar.frame.origin.y + self.indeicatorBar.frame.height,
                                    width: self.view.frame.width,
                                    height: self.view.frame.height - ScreenInfo.StatusBarHeght - self.indeicatorBar.frame.height)
        _viewpager.frame = viewPagerFrame
        _viewpager.setup(with: self.pagers(for: self._viewpager))
        _viewpager.pagers.forEach({  viewpager.addSubview($0.view) ;self.addChild($0)})
        _viewpager.scrollToPage(index: _curIndex,animation: false)
        scrollDelegate.scrollerView = _viewpager
        _viewpager.delegate = scrollDelegate;
        _viewpager.isPagingEnabled = true;
        _viewpager.showsHorizontalScrollIndicator = false;
        self.view.addSubview(_viewpager)
        
        self.scrollDelegate.whenScrollToLeftEdage = { [weak self] in
            self?.didScorllToLeftEdage()
        }
        self.scrollDelegate.whenScrollToRightEdage = { [weak self] in
            self?.didScorllToRightEdage()
        }
        self.scrollDelegate.whenScrollToPageIndex = { [weak self] index in
            self?._curIndex = index
            self?.didScrollToPage(index: index)
            self?._viewpager.scrollToPage(index: index)
            self?.indeicatorBar.scrollIndicator(to: index)
        }
        self.scrollDelegate.whenScrollPercent = { [weak self] precent in
            self?.didScroll(percent: precent)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        autoScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if autoScrollIndicator {
            self.indeicatorBar.scrollIndicator(to: curIndex,animated: false)
            //            if self._viewpager != nil{
            //                self.viewpager.scrollToPage(index: curIndex)
            //            }
        }
    }
    
    func didClickedIndicatorItem(index: Int){
        _viewpager.scrollToPage(index: index)
        self.didScrollToPage(index: index)
    }
    
    func didScroll(percent: CGFloat) {
        self.indeicatorBar.scrooIndicator(to: percent)
    }
    
    func defaultPageIndex()->Int{
        return 0
    }
    func titles(for viewpager: CRViewPager) -> [String] {
        fatalError("请覆写该方法")
    }
    func options(for viewpager: CRViewPager) -> [CRViewPagerIndecatorBarOption]? {
        fatalError("请覆写该方法")
    }
    func pagers(for viewpager: CRViewPager) -> [CRPager] {
        fatalError("请覆写该方法")
    }
    
    func didScrollToPage(index: Int) {
        fatalError("请覆写该方法")
    }
    func didScorllToLeftEdage() {
        fatalError("请覆写该方法")
    }
    func didScorllToRightEdage() {
        fatalError("请覆写该方法")
    }
}
