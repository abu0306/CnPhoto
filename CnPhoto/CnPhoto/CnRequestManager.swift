
//
//  CnRequestManager.swift
//  CnPhoto
//
//  Created by MyLifeIsNotLost on 2017/8/7.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//

import UIKit
import Photos

class CnRequestManager: NSObject {
    
    
    /// 列表图片展示
    ///
    /// - Parameters:
    ///   - asset: 图片对象
    ///   - completeHandler: 获取图片回调
    class func getListImage(_ asset:PHAsset?,completeHandler:@escaping (_ image:UIImage)->()) {
        let manager = PHImageManager.default()
        let RequestOptions = PHImageRequestOptions()
        RequestOptions.isSynchronous = false
        RequestOptions.resizeMode = .fast
        RequestOptions.deliveryMode = .opportunistic
        guard let asset = asset else { return }
        manager.requestImage(for: asset, targetSize: CGSize(width: photoListImgW * UIScreen.main.scale, height: photoListImgW  * UIScreen.main.scale), contentMode: .aspectFill, options: RequestOptions) { (img, _) in
            guard let img = img else{ return }
            completeHandler(img)
        }
    }
    
    /// 浏览大图图片
    ///
    /// - Parameters:
    ///   - asset: 图片对象
    ///   - completeHandler: 获取图片回调
    class func browsePictures(_ asset:PHAsset?,completeHandler:@escaping (_ image:UIImage)->()) {
        
        CnRequestManager.oriImage(asset) { (size) in
            let manager = PHImageManager.default()
            let RequestOptions = PHImageRequestOptions()
            RequestOptions.isSynchronous = false
            RequestOptions.resizeMode = .fast
            RequestOptions.deliveryMode = .fastFormat
            guard let asset = asset else { return }
            manager.requestImage(for: asset, targetSize: CGSize.zero, contentMode: .aspectFill, options: RequestOptions) { (img, _) in
                guard let img = img else{ return }
                completeHandler(img)
            }
        }
    }
    
   //获取原图尺寸比例
   private class func oriImage(_ asset:PHAsset?,completeHandler:@escaping (_ size:CGSize)->()) {
        let manager = PHImageManager.default()
        let RequestOptions = PHImageRequestOptions()
        RequestOptions.isSynchronous = false
        RequestOptions.resizeMode = .fast
        RequestOptions.deliveryMode = .fastFormat
        guard let asset = asset else { return }
        manager.requestImage(for: asset, targetSize: CGSize(width: photoListImgW * UIScreen.main.scale, height: photoListImgW  * UIScreen.main.scale), contentMode: .aspectFill, options: RequestOptions) { (img, _) in
            guard let img = img else{ return }
            completeHandler(img.size)
        }
    }
}

extension NSObject{
    
    func size(_ size : CGSize) {
        
        if size.width < size.height {
            let h = size.width * cnScreenH / size.height
            if h > cnScreenH {
                //固定高为cnScreenH屏幕高,等比缩小图片
            } else {
                //固定宽为屏幕宽,等比缩小
                
            }
            
        }else if size.width > size.height{
            
            
            
        }
        
    }
    
}






