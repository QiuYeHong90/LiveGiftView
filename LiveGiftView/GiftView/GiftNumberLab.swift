//
//  GiftNumberLab.swift
//  LiveGiftView
//
//  Created by ganhai on 2020/9/20.
//

import UIKit

class GiftNumberLab: UILabel {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(5)
        context?.setLineJoin(.round)
        context?.setTextDrawingMode(.stroke)
        textColor = UIColor.orange
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(.fill)
        textColor = UIColor.white
        super.drawText(in: rect)
    }
    
    func showNumAnimation(_ finishedBlock: @escaping ()->()) {
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }) { (isFinished) in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                self.transform = .identity
            }, completion: { (isFinished) in
                finishedBlock()
            })
        }
    }
    
}
