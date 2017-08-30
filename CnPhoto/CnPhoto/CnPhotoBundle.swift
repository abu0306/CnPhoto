//
//  CnPhotoBundle.swift
//  CnPhoto
//
//  Created by MyLifeIsNotLost on 2017/8/30.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//

import UIKit

private let CnPhotoBundleKey = "CnPhoto.bundle"
private let CnPhotoBundleName = "CnPhoto"
private let CnPhotoBundleType = "bundle"

class CnPhotoBundle: NSObject {
    class func CnPhotoImageWithName(_ name:String) -> UIImage {
        
        let v = UIImage(named: "CnPhoto.bundle/cnPhotoDefault")
//            CnPhotoBundle.CnPhotoPathForResource("ShanLinSDK.bundle/Face_back", "png")
        
        print(v ?? UIImage())
        
        guard let imagePath = CnPhotoBundle.CnPhotoPathForResource(name, "png") else {return UIImage()}
        return UIImage(contentsOfFile: imagePath)!
    }
    private class func CnPhotoPathForResource(_ name : String, _ type : String) -> String?{
        return Bundle.main.path(forResource: name, ofType: type, inDirectory: "ShanLinSDK.bundle")
    }
}
