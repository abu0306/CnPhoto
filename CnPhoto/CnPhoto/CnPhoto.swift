//
//  CnPhoto.swift
//  Appollo
//
//  Created by MyLifeIsNotLost on 2017/8/27.
//  Copyright © 2017年 shanlin. All rights reserved.
//

/**************************相册调用入口*******************************/

import UIKit
import Photos

extension UIViewController:CnPhotoProtocol{
    
    /// 相册默认导航
    ///
    /// - Parameter isDouble: 是否多选
  open func photoAlbum(_ isDouble : Bool) {
        privatePhotoAlbum(isDouble)
    }
    
    /// 相册自定义导航
    ///
    /// - Parameters:
    ///   - isDouble: 是否多选
    ///   - statusBarStyle: 状态栏颜色
    ///   - navBgColor: 导航颜色
    ///   - tintColor: 导航字体色
    ///   - bgColor: 试图背景色
    open func photoAlbum(_ isDouble : Bool,_ statusBarStyle : UIStatusBarStyle,_ navBgColor : UIColor, tintColor : UIColor,bgColor : UIColor) {
        privatePhotoAlbum(isDouble, statusBarStyle, navBgColor, tintColor: tintColor, bgColor: bgColor)
    }
    
    private func privatePhotoAlbum(_ isDouble : Bool? = true,_ statusBarStyle : UIStatusBarStyle? = .default,_ navBgColor : UIColor? = UIColor.white , tintColor : UIColor? = UIColor.black,bgColor:UIColor? = UIColor.black) {
        
        let vc = CnPhotoCollection()
        vc.delegate = self
        vc.bgColor = bgColor
        vc.navBgColor = navBgColor
        vc.tintColor = tintColor
        vc.isDoublePicker = isDouble ?? false
        if statusBarStyle == UIStatusBarStyle.default{
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true, completion: nil)
            
        }else{
            let nav = myNavigationController(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        }
    }
    
    
    
    /// 多选相册个数,Default : 9
    ///
    /// - Parameter count: _
    open func MultipleCounts(_ count:Int) {
        UserDefaults.standard.set(count, forKey: cnPhotoCountKey)
        UserDefaults.standard.synchronize()
    }
    
    open func MultipleDefaultImage(_ defaultImgName:String,_ selectImageName:String){
        UserDefaults.standard.set(defaultImgName, forKey: cnDefaultImgKey)
        UserDefaults.standard.set(selectImageName, forKey: cnselectImageKey)
        UserDefaults.standard.synchronize()
    }
}

