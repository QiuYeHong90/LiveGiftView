//
//  ViewController.swift
//  LiveGiftView
//
//  Created by shuhui on 2020/9/19.
//

import UIKit

class ViewController: UIViewController {
    
    var giftManager:GiftManager = GiftManager.init()
 
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func sendBtnClick(_ sender: UIButton) {
        if let key = sender.currentTitle {
            let model = GiftModel.init()
            
            print("click_giftkey______\(key)")
            model.key = key
            self.giftManager.addGiftView(with: self.view, model: model);
        }
        
        
        
        
        
    }
    
    
}

