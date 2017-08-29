
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
        
        CnRequestManager.oriImageScale(asset) { (size) in
            let manager = PHImageManager.default()
            let RequestOptions = PHImageRequestOptions()
            RequestOptions.isSynchronous = false
            RequestOptions.resizeMode = .exact
            RequestOptions.deliveryMode = .opportunistic
            guard let asset = asset else { return }
            
            let scacle = UIScreen.main.scale
            let width = scacle * cnScreenW
            let oriImageSize = CGSize(width: width, height: width * size.height / size.width)
            manager.requestImage(for: asset, targetSize: oriImageSize, contentMode: .aspectFill, options: RequestOptions) { (img, _) in
                guard let img = img else{ return }
                completeHandler(img)
            }
        }
    }
    
    
    /// 同步获取相册库原图
    ///
    /// - Parameters:
    ///   - asset: 图片对象
    ///   - completeHandler: 获取图片回调
    class func getBigPictures(_ asset:PHAsset?,completeHandler:@escaping (_ image:UIImage)->()) {
        
        CnRequestManager.oriImageScale(asset) { (size) in
            let manager = PHImageManager.default()
            let RequestOptions = PHImageRequestOptions()
            RequestOptions.isSynchronous = true
            RequestOptions.resizeMode = .exact
            RequestOptions.deliveryMode = .highQualityFormat
            guard let asset = asset else { return }
            let scacle = UIScreen.main.scale
            let width = scacle * cnScreenW
            let oriImageSize = CGSize(width: width, height: width * size.height / size.width)
            manager.requestImage(for: asset, targetSize: oriImageSize, contentMode: .aspectFill, options: RequestOptions) { (img, _) in
                guard let img = img else{ return }
                completeHandler(img)
            }
        }
    }
    
    //获取原图尺寸
    class func getOriImg(_ asset:PHAsset?,completeHandler:@escaping (_ img:UIImage)->()) {
        
        CnRequestManager.oriImageScale(asset) { (size) in
            
            let manager = PHImageManager.default()
            let RequestOptions = PHImageRequestOptions()
            RequestOptions.isSynchronous = false
            RequestOptions.resizeMode = .exact
            RequestOptions.deliveryMode = .highQualityFormat
            guard let asset = asset else { return }
            
            let scacle = UIScreen.main.scale
            let width = scacle * cnScreenW
            
            manager.requestImage(for: asset, targetSize: CGSize(width: width, height: width * size.height / size.width), contentMode: .aspectFill, options: RequestOptions) { (img, _) in
                guard let img = img else{ return }
                completeHandler(img)
            }
        }
    }
    
    //获取原图尺寸比例
    private class func oriImageScale(_ asset:PHAsset?,completeHandler:@escaping (_ size:CGSize)->()) {
        let manager = PHImageManager.default()
        let RequestOptions = PHImageRequestOptions()
        RequestOptions.isSynchronous = false
        RequestOptions.resizeMode = .fast
        RequestOptions.deliveryMode = .fastFormat
        guard let asset = asset else { return }
        manager.requestImage(for: asset, targetSize: CGSize(width: photoListImgW, height: photoListImgW), contentMode: .aspectFill, options: RequestOptions) { (img, _) in
            guard let img = img else{ return }
            completeHandler(img.size)
        }
    }
}






