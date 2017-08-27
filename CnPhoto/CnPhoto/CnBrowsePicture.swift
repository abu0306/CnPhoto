//
//  CnBrowsePicture.swift
//  CnPhoto
//
//  Created by MyLifeIsNotLost on 2017/8/23.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//

import UIKit
import Photos
private let cellID = "CnBrowsePicturesCell"

@objc protocol CnPrivateProtocol:NSObjectProtocol{
    //双击回调
    @objc optional func handleDoubleTap(_ point:CGPoint)
    /// 单击回调
    @objc optional func handleSingleTap()
}

@objc protocol CnPhotoProtocol:NSObjectProtocol{
    
    /// 单选照片回调
    ///
    /// - Parameter img: 回调值
    @objc optional func completeSinglePicture(_ img : UIImage)
    
}

class CnBrowsePicture: UIViewController {
    
    
    var aindexPath : IndexPath?
    
    /// 图片对象集
    var fetchResult : [PHAsset]?{
        didSet{
            mycollectionView.reloadData()
        }
    }
    
    lazy var navigationView: UIView = {
        let v = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: cnScreenW,
            height: 64
        ))
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    lazy var mycollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cnScreenW + 10, height: cnScreenH)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        let cv = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: cnScreenW + 10, height: cnScreenH), collectionViewLayout: layout)
        cv.isPagingEnabled = true
        return cv
    }()
    
    // 是否为多选 ,默认单选
    fileprivate lazy var isPictureDoublePicker =  {
        return UserDefaults.standard.bool(forKey: isDoublePickerKey)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.clear
        mycollectionView.delegate = self
        mycollectionView.dataSource = self
        view.addSubview(mycollectionView)
        mycollectionView.register(CnBrowsePicturesCell.classForCoder(), forCellWithReuseIdentifier: cellID)
        
        if isPictureDoublePicker {
            //多选未设置
            print("多选未设置")
        }else{
            singlePickerImgViewUI()
        }
        
        let topV = UIView(frame: CGRect(x: 0, y: (cnScreenH - cnScreenW) / 2.0, width: cnScreenW, height: 1))
        topV.backgroundColor = UIColor.white
        view.addSubview(topV)
        
        let bottomV = UIView(frame: CGRect(x: 0, y: (cnScreenH - cnScreenW) / 2.0 + cnScreenW, width: cnScreenW, height: 1))
        bottomV.backgroundColor = UIColor.white
        view.addSubview(bottomV)
        
    }
    
    @objc fileprivate func backBtnAction() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"){
            if let dict = NSDictionary(contentsOfFile: path){
                if let value = dict["UIViewControllerBasedStatusBarAppearance"] as? Bool{
                    if !value {
                        fatalError("\n****************请在Info.plist文件中设置key : View controller-based status bar appearance value : YES**************\n")
                    }
                }
                else{
                    fatalError("\n****************请在Info.plist文件中设置key : View controller-based status bar appearance value : YES**************\n")
                }
            }
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension CnBrowsePicture:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = fetchResult?.count else {  return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CnBrowsePicturesCell
        
        cell?.aindexPath = indexPath
        cell?.fetchResult = fetchResult
        cell?.reloadUI()
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        for v in cell.contentView.subviews {
            if let scrollView = v as? CnBrowseScrollView {
                scrollView.isDouble = false
                scrollView.setZoomScale(1, animated: false)
                break
            }
        }
    }
}

// MARK: - singlePicker
extension CnBrowsePicture{
    
    func singlePickerImgViewUI() {
        
        let bottomBgView = UIView(frame: CGRect.zero)
        bottomBgView.backgroundColor = UIColor.clear
        bottomBgView.frame = CGRect(x: 0, y: view.bounds.size.height - 64, width: cnScreenW, height: 64)
        view.addSubview(bottomBgView)
        
        let maskBgView = UIView(frame: CGRect.zero)
        maskBgView.alpha = 0.5
        maskBgView.backgroundColor = UIColor.black
        maskBgView.frame = CGRect(x: 0, y: 0, width: cnScreenW, height: 64)
        bottomBgView.addSubview(maskBgView)
        
        let cancleBtn = UIButton(type: .custom)
        cancleBtn.frame = CGRect(x: 0, y: 20, width: 100, height: 44)
        cancleBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(UIColor.white, for: .normal)
        cancleBtn.addTarget(self, action: #selector(singlePickerAction(_:)), for: .touchUpInside)
        bottomBgView.addSubview(cancleBtn)
        cancleBtn.tag = cancleBtnTAG
        
        let determineBtn = UIButton(type: .custom)
        determineBtn.frame = CGRect(x: cnScreenW - 100, y: 20, width: 100, height: 44)
        determineBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        determineBtn.setTitle("完成", for: .normal)
        determineBtn.setTitleColor(UIColor.white, for: .normal)
        determineBtn.addTarget(self, action: #selector(singlePickerAction(_:)), for: .touchUpInside)
        bottomBgView.addSubview(determineBtn)
        determineBtn.tag = determineBtnTAG
        
    }
    
    @objc private func singlePickerAction(_ sender : UIButton) {
        
        switch sender.tag {
        case cancleBtnTAG:
            //取消
            _ = navigationController?.popViewController(animated: true)
            break
        case determineBtnTAG:
            //确定
            
            let delegate = (navigationController?.viewControllers.first as? CnPhotoCollection)?.delegate
            if (delegate?.responds(to: #selector(CnPhotoProtocol.completeSinglePicture(_:)))) ?? false {
                
                guard let scrollView = (self.mycollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CnBrowsePicturesCell)?.myscrollView else { return }
                
                guard let clipImage = scrollView.imageV.image else { return }
                
                //imgView缩放比例
                
                print(scrollView.imageV.frame)
                
                let scaleImage = clipImage.imageCompressWithSimple(CGSize(width: scrollView.imageV.frame.size.width , height: scrollView.imageV.frame.size.height))
                
                let imgs = scaleImage.clipWithImageRect(CGRect(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y, width: cnScreenW, height: cnScreenW ))
                
                delegate?.completeSinglePicture!(imgs)
                self.dismiss(animated: true, completion: nil)
            }else{
                fatalError("没有实现_CnPhotoProtocol协议")
            }
            break
        default:
            break
        }
    }
}

