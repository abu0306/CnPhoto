//
//  ViewController.swift
//  CnPhoto
//
//  Created by MyLifeIsNotLost on 2017/8/7.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let myImageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        btn.backgroundColor = UIColor.yellow
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        view.addSubview(btn)
        
        myImageView.frame = CGRect(x: 0, y: 250, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.width)
        myImageView.backgroundColor = UIColor.green
        view.addSubview(myImageView)
        myImageView.contentMode = .scaleAspectFill
        myImageView.clipsToBounds = true
    }
    
//    /// UIImage异步回调
//    ///
//    /// - Parameter img: _
//    func completeSinglePicture(_ img: UIImage) {
//        myImageView.image = img
//    }
    
    
    /// UIImage同步回调
    ///
    /// - Parameters:
    ///   - img: _
    ///   - completeHandle: 回调控制
    func completeSinglePicture(_ img: UIImage, _ completeHandle: () -> ()) {
        myImageView.image = img
        completeHandle()
    }
    
    
    /// [UIImage]多选相册自定义导航异步回调
    ///
    /// - Parameter imgArray: _
//    func completeDoublePicture(_ imgArray: [UIImage]) {
//        myImageView.image = imgArray[0]
//        print(imgArray)
//    }
    
    /// [UIImage]多选相册自定义导航同步回调
    ///
    func completeSynchronousDoublePicture(_ imgArray: [UIImage], _ completeHandle: () -> ()) {
        
        myImageView.image = imgArray[0]
        print(imgArray)
        completeHandle()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func btnAction() {
        
        /// 单选相册默认导航
        //self.photoAlbum(false)
        
        //单选相册自定义导航
        self.photoAlbum(false, .lightContent, UIColor.black, tintColor: UIColor.white, bgColor: UIColor.white)
        
        /// 单选相册默认导航
        //self.photoAlbum(true)
        
        //多选相册自定义导航
        self.photoAlbum(true, .lightContent, UIColor.black, tintColor: UIColor.white, bgColor: UIColor.white)
    }

}

