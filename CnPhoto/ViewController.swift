//
//  ViewController.swift
//  CnPhoto
//
//  Created by abu on 2017/8/7.
//  Copyright © 2017年 abu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let myImageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btn_single = UIButton(type: .custom)
        btn_single.frame = CGRect(x: 50, y: 100, width: 100, height: 50)
        btn_single.backgroundColor = UIColor.yellow
        btn_single.setTitle("单选照片", for: .normal)
        btn_single.setTitleColor(UIColor.black, for: .normal)
        btn_single.addTarget(self, action: #selector(singleBtnAction1), for: .touchUpInside)
        view.addSubview(btn_single)
        
        let btn_double = UIButton(type: .custom)
        btn_double.frame = CGRect(x: cnScreenW - 150, y: 100, width: 100, height: 50)
        btn_double.backgroundColor = UIColor.yellow
        btn_double.setTitle("多选照片", for: .normal)
        btn_double.setTitleColor(UIColor.black, for: .normal)
        btn_double.addTarget(self, action: #selector(doubleBtnAction2), for: .touchUpInside)
        view.addSubview(btn_double)
        
        myImageView.frame = CGRect(x: 0, y: 250, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.width)
        myImageView.backgroundColor = UIColor.green
        view.addSubview(myImageView)
        myImageView.contentMode = .scaleAspectFill
        myImageView.clipsToBounds = true
    }
    
    
    /******************单选回调*********************/
    
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
    
    
    /******************多选回调*********************/
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
    
    /// 单选事件
    func singleBtnAction1() {
        
        /// 单选相册默认导航
        //self.photoAlbum(false)
        
        //单选相册自定义导航
        self.photoAlbum(false, .lightContent, UIColor.black, tintColor: UIColor.white, bgColor: UIColor.white)
    }
    
    /// 多选事件
    func doubleBtnAction2()  {
        /// 多选相册默认导航
        //self.photoAlbum(true)
        
        //多选相册自定义导航
        self.photoAlbum(true, .lightContent, UIColor.black, tintColor: UIColor.white, bgColor: UIColor.white)
        
    }

}

