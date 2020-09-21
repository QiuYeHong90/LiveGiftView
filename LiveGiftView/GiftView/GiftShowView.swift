//
//  GiftShowView.swift
//  LiveGiftView
//
//  Created by shuhui on 2020/9/19.
//

import UIKit



class GiftShowView: UIView,GiftItemViewProtocol {

    @IBOutlet weak var numberLab: GiftNumberLab!
    var status:GiftItemViewStatus = .ended
    /// 礼物开始出现，和结束的时候，回调
    var reloadAnimation:(()->Void)?
    /// 礼物结束动画完成结束
    var endFinshCall: ((GiftItemViewProtocol?) -> Void)?
    
    
    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var headerImgView: UIImageView!
    var model:GiftModel?{
        didSet{
            
            if  let m = self.model {
                self.numberLab.text = "x \(m.number)"
            }
        }
    }
   
    func ObjEndAnimation() {
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


