//
//  CnPhotoCollection.swift
//  photos
//
//  Created by abu on 2017/8/7.
//  Copyright © 2017年 abu. All rights reserved.
//

import UIKit
import Photos
private let bottomViewHeight : CGFloat = 44

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
            UserDefaults.standard.set(isDoublePicker, forKey: cnIsDoublePickerKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate var mylistView : CnPhotoList?
    fileprivate var fetchResult : PHFetchResult<PHAsset>?
    
    weak var delegate : CnPhotoProtocol?
    
    lazy var navBarView = UIView()
    
    lazy var bottomBgView = UIView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhotoAlbumPermissions()
        setupUI()
        
        let ins = UserDefaults.standard.integer(forKey: cnPhotoCountKey)
        if ins == 0{
            UserDefaults.standard.set(9, forKey: cnPhotoCountKey)
            UserDefaults.standard.synchronize()
        }
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
        automaticallyAdjustsScrollViewInsets = false
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
    
    fileprivate  func dobulePickerImgViewUI() {
        
        bottomBgView.backgroundColor = UIColor.clear
        bottomBgView.frame = CGRect(x: 0, y: view.bounds.size.height - bottomViewHeight, width: cnScreenW, height: bottomViewHeight)
        view.addSubview(bottomBgView)
        
        let maskBgView = UIView(frame: CGRect.zero)
        maskBgView.backgroundColor = UIColor.black
        maskBgView.alpha = 0.6
        maskBgView.frame = CGRect(x: 0, y: 0, width: cnScreenW, height: bottomViewHeight)
        bottomBgView.addSubview(maskBgView)
        
        let cancleBtn = UIButton(type: .custom)
        cancleBtn.frame = CGRect(x: 15, y: 8, width: 60, height: bottomViewHeight - 16)
        cancleBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cancleBtn.setTitle("预览", for: .normal)
        cancleBtn.setTitleColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7), for: .normal)
        cancleBtn.addTarget(self, action: #selector(singlePickerAction(_:)), for: .touchUpInside)
        bottomBgView.addSubview(cancleBtn)
        
        cancleBtn.tag = cancleBtnTAG
        
        let determineBtn = UIButton(type: .custom)
        determineBtn.frame = CGRect(x: cnScreenW - 75, y: 8, width: 60, height: bottomViewHeight - 16)
        
        determineBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        determineBtn.setTitle("完成", for: .normal)
        determineBtn.backgroundColor = UIColor(red: 81.0/255.0, green: 169.0/255.0, blue: 56.0/255.0, alpha: 1)
            
        determineBtn.setTitleColor(UIColor.white, for: .normal)
        determineBtn.addTarget(self, action: #selector(singlePickerAction(_:)), for: .touchUpInside)
        determineBtn.layer.cornerRadius = 3.0
        determineBtn.layer.masksToBounds = true
        bottomBgView.addSubview(determineBtn)
        determineBtn.tag = determineBtnTAG
        
    }

    @objc fileprivate func singlePickerAction(_ sender : UIButton) {
        switch sender.tag {
        case cancleBtnTAG:
            //预览
            var localResult = [PHAsset]()
            guard let doubleStatusCollection = mylistView?.doubleStatusCollection else {  return  }
            for value in doubleStatusCollection {
                guard let fr = fetchResult?[value]  else {break}
                localResult.append(fr)
            }
            let vc  = CnBrowsePicture()
            vc.fetchResult = localResult
            vc.doubleStatusCollection = doubleStatusCollection
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            //完成
            
            let delegate = (navigationController?.viewControllers.first as? CnPhotoCollection)?.delegate
            
            var localResult = [PHAsset]()
            guard let doubleStatusCollection = mylistView?.doubleStatusCollection else {  return  }
            for value in doubleStatusCollection {
                guard let fr = fetchResult?[value]  else {break}
                localResult.append(fr)
            }

            var imgArray = [UIImage]()
            
            if (delegate?.responds(to: #selector(CnPhotoProtocol.completeSynchronousDoublePicture(_:_:)))) ?? false {
                
                for assetValue in localResult {
                    CnRequestManager.getBigPictures(assetValue, completeHandler: { (img) in
                        imgArray.append(img)
                        if  localResult.count == imgArray.count {
                            delegate?.completeSynchronousDoublePicture!(imgArray, {
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    })
                }
                return
            }else{
                if (delegate?.responds(to: #selector(CnPhotoProtocol.completeDoublePicture(_:)))) ?? false {
                    for assetValue in localResult {
                        CnRequestManager.getBigPictures(assetValue, completeHandler: { (img) in
                            imgArray.append(img)
                            if  localResult.count == imgArray.count {
                                delegate?.completeDoublePicture!(imgArray)
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                    return
                }else{
                    fatalError("没有实现_CnPhotoProtocol协议")
                }
            }
            break
        }
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
            let assetC  = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil).lastObject
            if assetC == nil
            {
                let v = CnUserDisable(frame: CGRect(x: 0, y: 64, width: cnScreenW, height: cnScreenH - 64))
                view.addSubview(v)
                v.type = authorNum.first
                return
            }
            
            let listH : CGFloat = isDoublePicker ? (64 + bottomViewHeight) : 64
            let v = CnPhotoList(frame: CGRect(x: 0, y: 64, width: cnScreenW, height: cnScreenH - listH))
            v.assetCollection = assetC
            view.addSubview(v)
            mylistView = v
            
            func getFetchResult(_ asset:PHAssetCollection?) {
                guard let asset = asset else { return }
                fetchResult = PHAsset.fetchAssets(in: asset, options: nil)
            }

            if isDoublePicker {
                getFetchResult(assetC)
                dobulePickerImgViewUI()
            }
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
