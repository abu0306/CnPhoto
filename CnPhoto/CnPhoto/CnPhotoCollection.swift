//
//  CnPhotoCollection.swift
//  photos
//
//  Created by MyLifeIsNotLost on 2017/8/7.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//

import UIKit
import Photos
enum authorNum:Int {
    case first
    case denied
}


class myNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}


class CnPhotoCollection: UIViewController {
    
    var bgColor : UIColor?
    var navBgColor : UIColor?
    var tintColor : UIColor?
    
    /// 是否是单选 Default : true
    var isDoublePicker = true{
        didSet{
            UserDefaults.standard.set(isDoublePicker, forKey: isDoublePickerKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    weak var delegate : CnPhotoProtocol?
    
    lazy var navBarView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getPhotoAlbumPermissions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc fileprivate func btnAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupUI(){
        view.backgroundColor = bgColor
        title = "相册"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : tintColor ?? UIColor.black]
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(tintColor, for: .normal)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        let navBarItem = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItem = navBarItem
        
        navBarView.frame = CGRect(x: 0, y: 0, width: cnScreenW, height: 64)
        navBarView.alpha = 0.7
        navBarView.backgroundColor = navBgColor
        view.addSubview(navBarView)
    }
}

extension CnPhotoCollection{
    //获取相册权限
    func getPhotoAlbumPermissions() {
        let authorStatus = PHPhotoLibrary.authorizationStatus()
        
        if authorStatus == PHAuthorizationStatus.restricted || authorStatus == PHAuthorizationStatus.denied{
            //无权限(用户禁止)
            let v = CnUserDisable(frame: CGRect(x: 0, y: 64, width: cnScreenW, height: cnScreenH - 64))
            view.addSubview(v)
            v.type = authorNum.denied
            
            return
        }
        else{
            let assetCollection  = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil).lastObject
            if assetCollection == nil
            {
                let v = CnUserDisable(frame: CGRect(x: 0, y: 64, width: cnScreenW, height: cnScreenH - 64))
                view.addSubview(v)
                v.type = authorNum.first
                return
            }
            
            let v = CnPhotoList(frame: CGRect(x: 0, y: 64, width: cnScreenW, height: cnScreenH - 64))
            v.assetCollection = assetCollection
            view.addSubview(v)
        }
    }
}

//MARK: - 没有或者禁用图片展示View
class CnUserDisable: UIView {
    fileprivate lazy var MSgAlert = UILabel()
    var type : authorNum?
    override func layoutSubviews() {
        setupUI()
    }
    
    func setupUI() {
        
        backgroundColor = UIColor.white
        MSgAlert.font = UIFont(name: "PingFangSC-Regular", size: 14)
        MSgAlert.numberOfLines = 0
        MSgAlert.textAlignment = .center
        MSgAlert.textColor = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
        addSubview(MSgAlert)
        
        var title = ""
        
        guard let type = type else { return  }
        
        switch type {
        case .denied:
            title = "请在iPhone的“设置-隐私-照片”选项中，\n允许买卖时间访问你的相册。"
            break
        default:
            title = "无照片"
            break
        }
        
        MSgAlert.text = title
        MSgAlert.sizeToFit()
        MSgAlert.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: MSgAlert.bounds.height)
    }
}
