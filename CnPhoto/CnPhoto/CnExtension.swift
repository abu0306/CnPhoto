//
//  CnExtension.swift
//  CnPhoto
//
//  Created by MyLifeIsNotLost on 2017/8/9.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//

import UIKit

extension UIView{
    
    func cnViewController() -> UIViewController? {
        //通过响应者链，取得此视图所在的视图控制器
        var nextVC = self.next
        
        while(nextVC != nil) {
            //判断响应者对象是否是视图控制器类型
            if (nextVC?.isKind(of: UIViewController.self))! {
                return nextVC as? UIViewController
            }
            
            nextVC = nextVC?.next
        }
        return nil;
    }
}
