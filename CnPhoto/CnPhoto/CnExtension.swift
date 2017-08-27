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
    

    //    func clipWithImageRect(_ clipRect :CGRect ,_ clipImage : UIImage)->UIImage{
    //        let scale = UIScreen.main.scale
    //       let sourceImageRef: CGImage = clipImage.cgImage!
    //       guard let newImg = sourceImageRef.cropping(to: CGRect(x: clipRect.origin.x , y: clipRect.origin.y , width: cnScreenW, height: cnScreenW)) else { return UIImage()}
    //        let Image = UIImage(cgImage: newImg)
    //        return Image
    //
    //    }
}

extension UIImage{
    
        func clipWithImageRect(_ clipRect :CGRect )->UIImage{
            let scale = UIScreen.main.scale
           let sourceImageRef: CGImage = self.cgImage!
           guard let newImg = sourceImageRef.cropping(to: CGRect(x: clipRect.origin.x  * scale , y: clipRect.origin.y * scale , width: clipRect.width * scale, height: clipRect.height * scale)) else { return UIImage()}
            let Image = UIImage(cgImage: newImg)
            return Image
    
        }
    
//    func clipWithImageRect(_ clipRect :CGRect)->UIImage{
//        
//        _ = UIScreen.main.scale
//        //        /// hu
//        UIGraphicsBeginImageContext(CGSize(width: clipRect.width, height: clipRect.width))
//        self.draw(in: CGRect(x: clipRect.origin.x, y: clipRect.origin.y, width: size.width,  height: size.height))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage ?? UIImage()
//        
//    }
    
    
    func imageCompressWithSimple(_ scaledToSize : CGSize) -> UIImage {
        return reSizeImage(reSize: scaledToSize)
    }
    
    
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return reSizeImage ?? UIImage()
    }
    
    
    //    func imageCompressWithSimple(_ scaledToSize : CGSize) -> UIImage {
    //        let scale = UIScreen.main.scale
    //        /// hu
    //        UIGraphicsBeginImageContext(CGSize(width: scaledToSize.width, height: scaledToSize.height))
    //        self.draw(in: CGRect(x: 0, y: 0, width: size.width,     height: size.height))
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //        return newImage ?? UIImage()
    //    }
    //
    //    func imageCompressWithSimple( _ scale : CGFloat)-> UIImage  {
    //        let size = self.size
    //        let w = size.width
    //        let h = size.height
    //        let scaledWidth = w * scale
    //
    //
    //
    //        return UIImage()
    //    }
    
    //    - (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale
    //    {
    //    CGSize size = image.size;
    //    CGFloat width = size.width;
    //    CGFloat height = size.height;
    //    CGFloat scaledWidth = width * scale;
    //    CGFloat scaledHeight = height * scale;
    //    UIGraphicsBeginImageContext(size); // this will crop
    //    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    //    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return newImage;
    //    }
}
