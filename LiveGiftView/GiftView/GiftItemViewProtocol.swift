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

@objc protocol BaseItemViewProtocol {
    @objc func ObjEndAnimation() ;
}


protocol GiftItemViewProtocol:UIView,BaseItemViewProtocol {
    
    var numberLab: GiftNumberLab!{set get}
    /// 礼物结束动画完成结束
    var endFinshCall:((GiftItemViewProtocol?)->Void)?{set get}
    /// 礼物开始出现，和结束的时候，回调
    var reloadAnimation:(()->Void)?{set get}
    /// 初始值 ended
    var status:GiftItemViewStatus{set get}
    var model:GiftModel?{set get}
    static func createViewWith(supV:UIView,reloadAnimation:@escaping (()->Void),endFinshCall:@escaping ((GiftItemViewProtocol?)->Void)) -> GiftItemViewProtocol ;
    ///    更新布局
    func layoutIn();
    func showAnimation();
    /// 机选展示连续点击
    /// - Parameter isContinueClick: 是否连续点击
    func showStatus(isContinueClick:Bool);
    
}

extension GiftItemViewProtocol{
    
    static func createViewWith(supV: UIView, reloadAnimation: @escaping (() -> Void), endFinshCall: @escaping ((GiftItemViewProtocol?) -> Void)) -> GiftItemViewProtocol {
        
        let view:GiftItemViewProtocol = Bundle.main.loadNibNamed("\(Self.self)", owner: nil, options: nil)!.first as! GiftItemViewProtocol
        view.layoutIn()
        view.alpha = 0
        view.reloadAnimation = reloadAnimation
        view.endFinshCall = endFinshCall
        supV.addSubview(view)
        
        view.frame = CGRect.init(x: -GiftManager.itemW, y: GiftManager.maxY, width: GiftManager.itemW, height: GiftManager.itemH)
//        view.backgroundColor = UIColor.red
        
        
        return view
    }
    
    /// 机选展示连续点击
    /// - Parameter isContinueClick: 是否连续点击
    func showStatus(isContinueClick:Bool = false) {
        self.status = .show
        self.isHidden = false
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        self.perform(#selector(self.ObjEndAnimation), with: nil, afterDelay: 3)
        if let key = self.model?.key {
            print("showStatus_giftkey______\(key)")
        }
        if isContinueClick {
            self.numberLab.showNumAnimation {
                
            }
        }
        
    }
    
    
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
