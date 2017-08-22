//
//  CnCommon.swift
//  CnPhoto
//
//  Created by MyLifeIsNotLost on 2017/8/7.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//

import UIKit

/// 背景主色调
let mainViewBackColor = UIColor.white

/// 屏幕宽
let cnScreenW = UIScreen.main.bounds.width

/// 屏幕高
let cnScreenH = UIScreen.main.bounds.height

/// 相册列表列数
let photoListColumn = CGFloat(4)

/// 相册列间隙
let photoListSapace = CGFloat(3)

/// 相册图片宽
let photoListImgW = (cnScreenW - (photoListColumn - 1) * photoListSapace)/photoListColumn

		