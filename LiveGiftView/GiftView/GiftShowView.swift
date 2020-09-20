//
//  GiftShowView.swift
//  LiveGiftView
//
//  Created by shuhui on 2020/9/19.
//

import UIKit

class GiftShowView: UIView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var numberLab: GiftNumberLab!
    @IBOutlet weak var headerImgView: UIImageView!
    var model:GiftModel?{
        didSet{
            
            if  let m = self.model {
                self.numberLab.text = "x \(m.number)"
            }
        }
    }
    
    
    enum GiftShowStatus:Int {
        /// 展示中
        case show = 0
        /// 正在结束动画向左
        case ending0
        /// 正在结束动画高度变小
        case ending1
        /// 已经结束闲置状态
        case ended
    }
    var status:GiftShowStatus = .ended
    
    var endAnimatinCall:(()->Void)?
    var endFinshCall:(()->Void)?
    
    class func createViewWith(supV:UIView,endAnimatinCall:@escaping (()->Void),endFinshCall:@escaping (()->Void)) -> GiftShowView {
        
         
        let view:GiftShowView = Bundle.main.loadNibNamed("GiftShowView", owner: nil, options: nil)!.first as! GiftShowView
        view.layoutIn()
        
        view.endAnimatinCall = endAnimatinCall
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
        
        self.perform(#selector(self.endAnimation), with: nil, afterDelay: 3)
        if let key = self.model?.key {
            print("showStatus_giftkey______\(key)")
        }
        if isContinueClick {
            self.numberLab.showNumAnimation {
                
            }
        }
        
    }
    
    func showAnimation() {
        self.showStatus()
        
        var rect = self.frame
        rect.origin.x = 0
        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
            self.frame = rect
        } completion: { (falg) in
            
        }

        

        
      
       
        
    }
    
    @objc func endAnimation() {
        if let key = self.model?.key {
            print("endAnimation_giftkey______\(key)")
        }
        self.status = .ending0
        var rect = self.frame
        rect.origin.x = -GiftManager.itemW
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseIn) {
            self.frame = rect
        } completion: { (falg) in
            self.status = .ending1
            rect.size.height = 0
            self.frame = rect
            UIView.animate(withDuration: 0.25) {
                self.endAnimatinCall?()
                
            } completion: { (falg) in
                self.status = .ended
                
                self.endFinshCall?()
            }

        }
        
        

    }
    
   
    
    func layoutIn() {
        self.bgView.layer.cornerRadius = self.bgView.bounds.size.height/2
        self.headerImgView.layer.cornerRadius = self.headerImgView.bounds.size.height/2
        self.headerImgView.clipsToBounds = true
    }
}