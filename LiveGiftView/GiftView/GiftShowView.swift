//
//  GiftShowView.swift
//  LiveGiftView
//
//  Created by shuhui on 2020/9/19.
//

import UIKit



class GiftShowView: UIView,GiftItemViewProtocol {
    
    static func createViewWith(supV: UIView, reloadAnimation: @escaping (() -> Void), endFinshCall: @escaping ((GiftItemViewProtocol?) -> Void)) -> GiftItemViewProtocol {
        
        let view:GiftShowView = Bundle.main.loadNibNamed("GiftShowView", owner: nil, options: nil)!.first as! GiftShowView
        view.layoutIn()
        view.alpha = 0
        view.reloadAnimation = reloadAnimation
        view.endFinshCall = endFinshCall
        supV.addSubview(view)
        
        view.frame = CGRect.init(x: -GiftManager.itemW, y: GiftManager.maxY, width: GiftManager.itemW, height: GiftManager.itemH)
//        view.backgroundColor = UIColor.red
        
        
        return view
    }
    var status:GiftItemViewStatus = .ended
    /// 礼物开始出现，和结束的时候，回调
    var reloadAnimation:(()->Void)?
    /// 礼物结束动画完成结束
    var endFinshCall: ((GiftItemViewProtocol?) -> Void)?
    
    
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
   
    

    
    
    /// 机选展示连续点击
    /// - Parameter isContinueClick: 是否连续点击
    func showStatus(isContinueClick:Bool = false) {
        self.status = .show
        self.isHidden = false
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        self.perform(#selector(self.myEndAnimation), with: nil, afterDelay: 3)
        if let key = self.model?.key {
            print("showStatus_giftkey______\(key)")
        }
        if isContinueClick {
            self.numberLab.showNumAnimation {
                
            }
        }
        
    }
    
    
    @objc func myEndAnimation() {
        self.endAnimation()
    }
    func layoutIn() {
        self.bgView.layer.cornerRadius = self.bgView.bounds.size.height/2
        self.headerImgView.layer.cornerRadius = self.headerImgView.bounds.size.height/2
        self.headerImgView.clipsToBounds = true
    }
    
    deinit {
        print("释放了  \(self)");
    }
}


