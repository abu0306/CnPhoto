//
//  CnPhotoBundle.swift
//  CnPhoto
//
//  Created by abu on 2017/8/30.
//  Copyright © 2017年 abu. All rights reserved.
//

import UIKit

private let CnPhotoBundleKey = "CnPhoto.bundle"
private let CnPhotoBundleName = "CnPhoto"
private let CnPhotoBundleType = "bundle"

class CnPhotoBundle: NSObject {
    class func CnPhotoImageWithName(_ name:String) -> UIImage {
        if let imgView = UIImage(named: "Frameworks/CnPhoto.framework/CnPhoto.bundle/\(name)"){
            return imgView
        }
        if let imgView = UIImage(named: "CnPhoto.bundle/\(name)") {
            return imgView
        }
        return UIImage()
    }
}
