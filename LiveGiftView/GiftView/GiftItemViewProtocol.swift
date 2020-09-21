//
//  GiftProptt.swift
//  LiveGiftView
//
//  Created by ganhai on 2020/9/21.
//

import UIKit


enum GiftItemViewStatus:Int {
    /// 展示中
    case show = 0
    /// 正在结束动画向左
    case ending0
    /// 正在结束动画高度变小
    case ending1
    /// 已经结束闲置状态
    case ended
}
protocol GiftItemViewProtocol:UIView {
    /// 礼物结束动画完成结束
    var endFinshCall:((GiftItemViewProtocol?)->Void)?{set get}
    /// 礼物开始出现，和结束的时候，回调
    var reloadAnimation:(()->Void)?{set get}
    /// 初始值 ended
    var status:GiftItemViewStatus{set get}
    var model:GiftModel?{set get}
    static func createViewWith(supV:UIView,reloadAnimation:@escaping (()->Void),endFinshCall:@escaping ((GiftItemViewProtocol?)->Void)) -> GiftItemViewProtocol ;
    
    func showAnimation();
    /// 机选展示连续点击
    /// - Parameter isContinueClick: 是否连续点击
    func showStatus(isContinueClick:Bool);
    
}

extension GiftItemViewProtocol{
    func showAnimation() {
        self.showStatus(isContinueClick: false)
        self.alpha = 0
        var rect = self.frame
        rect.origin.x = 0
        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
            self.alpha = 1
            self.frame = rect
            self.reloadAnimation?()
            
        } completion: { (falg) in
            
        }
    }
    
    
    func endAnimation() {
        if let key = self.model?.key {
            print("endAnimation_giftkey______\(key)")
        }
        self.status = .ending0
        var rect = self.frame
        rect.origin.x = -GiftManager.itemW
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseIn) {
            self.frame = rect
            self.alpha = 0
        } completion: { (falg) in
            self.isHidden = true
            
            self.status = .ending1
            rect.size.height = 0
            self.frame = rect
            UIView.animate(withDuration: 0.25) {
                self.reloadAnimation?()
                
            } completion: { (falg) in
                
                self.status = .ended
                
                self.endFinshCall?(self)
            }

        }
        
        

    }
    
}
