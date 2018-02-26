//
//  CnPhotoProtocol.swift
//  Appollo
//
//  Created by abu on 2017/8/27.
//  Copyright © 2017年 abu. All rights reserved.
//

import UIKit

@objc public protocol CnPhotoProtocol:NSObjectProtocol{
    
    
    /// 单选照片同步回调协议
    ///
    /// - Parameters:
    ///   - img: 回调Img
    ///   - completeHandle: 相册界面消失控制
    @objc optional func completeSinglePicture(_ img : UIImage,_ completeHandle : ()->())
    
    /// 单选照片异步回调协议
    ///
    /// - Parameters:
    ///   - img: 回调Img
    @objc optional func completeSinglePicture(_ img : UIImage)
    
    /// 双选相册同步回调
    ///
    /// - Parameter imgArray: _
    @objc optional func completeSynchronousDoublePicture(_ imgArray : [UIImage],_ completeHandle : ()->())
    
    /// 双选相册同步回调
    ///
    /// - Parameter imgArray: _
    @objc optional func completeDoublePicture(_ imgArray : [UIImage])
    
    
    @objc optional func storedImgData(_ img : UIImage,_ withPath : String)
}
