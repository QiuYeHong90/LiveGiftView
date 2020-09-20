//
//  GiftManager.swift
//  LiveGiftView
//
//  Created by shuhui on 2020/9/19.
//

import UIKit

class GiftManager: NSObject {
    
    /// 超过最大数量缓存起来
    var cacheModels:[GiftModel] = [GiftModel]();
    
    static let itemW:CGFloat = 230
    static let itemH:CGFloat = 40
    /// 最下面的y值坐标
    static let maxY = UIScreen.main.bounds.size.height - 200
    /// 最大展示数量
    var maxShowCount = 3
    
    
    /// 重用礼物view
    var giftViews:[GiftShowView] = [GiftShowView]()
    
    /// 缓存父类视图
    var superView:UIView?
    
    
    /// 添加横幅礼物
    /// - Parameters:
    ///   - superView: 父类视图
    ///   - model: 数据模型
    func addGiftView(with superView:UIView,model:GiftModel) {
        self.superView = superView
        if self.giftIsShow(with: model) {
            return
        }
        
        
        var giftView:GiftShowView? = self.giftViewEndedView()
        
        if giftView == nil {
            let view = GiftShowView.createViewWith(supV: superView) {
                [weak self] in
                
                self?.reloadGiftViewsAnimation()
                
                
            } endFinshCall: {
                
                [weak self] (itemView)in
                if let v = itemView{
                    self?.restXZViewFrame(itemView: v);
                }
                if let spV = self?.superView{
                    if let firstM = self?.cacheModels.first {
                        self?.cacheModels.removeFirst()
                        self?.addGiftView(with: spV , model: firstM)
                    }
                    
                    
                }
                
                
            }
            
            
            
            self.giftViews.append(view)
            
            giftView = view;
        }
        
        guard let view = giftView else {
            return
        }
        
        let showCount = self.giftStatsShowCount()
        if showCount < self.maxShowCount {
            
            var rect = CGRect.init(x: -GiftManager.itemW, y: GiftManager.maxY, width: GiftManager.itemW, height: GiftManager.itemH) ;
            rect.origin.y = rect.origin.y - CGFloat(showCount) * (rect.height + 13);
            view.frame = rect
            view.model = model
            view.showAnimation()
        }else{
//            缓存起来
            self.appendCacheModel(model: model)
        }
        
        
        
        
    }
    
    
    
    /// 添加到缓存
    /// - Parameter model: 模型数据
    func appendCacheModel(model:GiftModel) {
        
        for item in self.cacheModels {
            if item.key == model.key {
                item.number += model.number
                print("addNumber_giftkey______\(item.key)")
                return
            }
        }
        self.cacheModels.append(model)
    }
    
    /// 送达礼物是否正在展示
    /// - Parameter model: 数据
    /// - Returns: 是否
    func giftIsShow(with model:GiftModel) -> Bool {
        
        for item in self.giftViews {
            if item.status == .show,let itemM = item.model {
                if itemM.key == model.key {
                    
                    model.number += itemM.number
                    
                    item.model = model
                    item.showStatus(isContinueClick: true)
                    return true
                }
                
            }
        }
        return false
    }
    
    /// 闲置的view
    /// - Returns: view
    func giftViewEndedView() -> GiftShowView? {
        
        for (index,item) in self.giftViews.enumerated() {
            if item.status == .ended {
//                找到闲置的把它放后面
                self.giftViews.remove(at: index)
                self.giftViews.append(item)
                return item
            }
        }
        return nil
    }
    
    func restXZViewFrame(itemView:GiftShowView) {
        var rect = itemView.frame
        rect.size.height = GiftManager.itemH
        itemView.frame = rect
        for (index,item) in self.giftViews.enumerated() {
            if itemView == item {
//                找到闲置的把它放后面
                
                self.giftViews.remove(at: index)
                self.giftViews.append(item)
               
            }
        }
    }
    
    //    正在展示的数量
    func giftStatsShowCount() -> Int {
        var count:Int = 0
        for item in self.giftViews {
            if item.status != .ended {
                
                count += 1
            }
        }
        
        return count
    }
    
    /// 一个礼物消失，其他正在展示的礼物横幅下滑,或者礼物开始的时候，检查所有布局
    func reloadGiftViewsAnimation() {
        var index:Int = 0
        for item in self.giftViews {
            if item.status != .ended,item.status != .ending1 {
                var rect = item.frame ;
                
                rect.origin.y = GiftManager.maxY - CGFloat(index) * (rect.height + 13);
                item.frame = rect
                
                index += 1

            }else{

            }
            
        }
    }
    
    
    func removeAllGifts() {
        
        for item in self.giftViews {
            item.removeFromSuperview()
        }
        
        self.giftViews.removeAll()
        
        
        
    }
}
