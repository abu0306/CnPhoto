//
//  CnExtension.swift
//  CnPhoto
//
//  Created by abu on 2017/8/9.
//  Copyright © 2017年 abu. All rights reserved.
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

extension UIImage{
    
    /// 剪切UIImage
    ///
    /// - Parameter clipRect: 剪切CGRect
    /// - Returns: 剪切后UIImage
    open func clipWithImageRect(_ clipRect :CGRect )->UIImage{
        let scale = UIScreen.main.scale
        let sourceImageRef: CGImage = self.cgImage!
        guard let newImg = sourceImageRef.cropping(to: CGRect(x: clipRect.origin.x  * scale , y: clipRect.origin.y * scale , width: clipRect.width * scale, height: clipRect.height * scale)) else { return UIImage()}
        let Image = UIImage(cgImage: newImg)
        return Image
        
    }
    
    /// 等比缩放UIImage
    ///
    /// - Parameter scaledToSize: 缩小的大小
    /// - Returns: 缩小后的UIImage
    open  func imageCompressWithSimple(_ scaledToSize : CGSize) -> UIImage {
        return reSizeImage(reSize: scaledToSize)
    }
    
    private func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return reSizeImage ?? UIImage()
    }
}
