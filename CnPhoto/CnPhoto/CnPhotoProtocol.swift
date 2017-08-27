//
//  CnPhotoProtocol.swift
//  Appollo
//
//  Created by MyLifeIsNotLost on 2017/8/27.
//  Copyright © 2017年 shanlin. All rights reserved.
//

import UIKit

@objc protocol CnPhotoProtocol:NSObjectProtocol{
    
    
    /// 单选照片回调协议
    ///
    /// - Parameters:
    ///   - img: 回调Img
    ///   - completeHandle: 相册界面消失控制
    @objc optional func completeSinglePicture(_ img : UIImage,_ completeHandle : ()->())
    
    /// 单选照片回调协议
    ///
    /// - Parameters:
    ///   - img: 回调Img
    @objc optional func completeSinglePicture(_ img : UIImage)
    
    @objc optional func storedImgData(_ img : UIImage,_ withPath : String)
}
