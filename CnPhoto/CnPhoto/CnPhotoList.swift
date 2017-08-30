//
//  CnPhotoList.swift
//  CnPhoto
//
//  Created by MyLifeIsNotLost on 2017/8/7.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//

import UIKit
import Photos
private let cellID = "CnPhotoListCell"

class CnPhotoList: UIView {
    
    fileprivate lazy var mycollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: photoListImgW, height: photoListImgW)
        layout.minimumLineSpacing = photoListSapace
        layout.minimumInteritemSpacing = photoListSapace
        let c = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return c
    }()
    
    // 是否为多选 ,默认单选
    fileprivate lazy var IsPictureDoublePicker =  {
        return UserDefaults.standard.bool(forKey: cnIsDoublePickerKey)
    }()
    
    lazy var doubleStatusCollection = [Int]()
    
    /// 图片对象
    var assetCollection : PHAssetCollection?
    
    /// 图片对象集
    fileprivate var fetchResult : PHFetchResult<PHAsset>?
    
    deinit {
        //  移除观察者
        mycollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        getFetchResult(assetCollection)
    }
    
    
    /// 是否滚动到底部
    fileprivate var isScrollBottom = false
    
    
    /// 获取图片集合
    ///
    /// - Parameter asset: 图片对象
    fileprivate  func getFetchResult(_ asset:PHAssetCollection?) {
        guard let asset = asset else { return }
        fetchResult = PHAsset.fetchAssets(in: asset, options: nil)
        mycollectionView.reloadData()
    }
    
    fileprivate func setupUI(_ frame:CGRect){
        mycollectionView.backgroundColor = UIColor.clear
        mycollectionView.frame = CGRect(x: 0, y: 0, width: cnScreenW, height: frame.size.height)
        mycollectionView.delegate = self
        mycollectionView.dataSource = self
        mycollectionView.alwaysBounceVertical = true
        addSubview(mycollectionView)
        
        //单元格注册
        mycollectionView.register(CnPhotoListCell.classForCoder(), forCellWithReuseIdentifier: cellID)
        
        mycollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension CnPhotoList:UICollectionViewDelegate,UICollectionViewDataSource{
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = fetchResult?.count else { return 0 }
        return count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CnPhotoListCell
        cell?.aIndexPath = indexPath
        cell?.fetchResult = fetchResult
        cell?.doubleStatusCollection = doubleStatusCollection
        cell?.reloadData()
        cell?.reloadHook()
        return cell!
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let fr = fetchResult else {
            fatalError("*********没有获取到图像集*********")
        }
        
        if UserDefaults.standard.bool(forKey: cnIsDoublePickerKey) {
            
            let isContains = doubleStatusCollection.contains(indexPath.row)
            
            if isContains {
                
               let valueIndex = doubleStatusCollection.index(where: { (value) -> Bool in
                    return value == indexPath.row
                })
                if let i  = valueIndex {
                    doubleStatusCollection.remove(at: i)
                }
            }else{
                
                let count =  UserDefaults.standard.integer(forKey: cnPhotoCountKey)
                
                if count > 0 && count == doubleStatusCollection.count {
                    let alertVC = UIAlertController(title: nil, message: "你最多只能选择\(count)张照片", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
                    alertVC.addAction(cancelAction)
                    self.cnViewController()?.present(alertVC, animated: true, completion: nil)
                    return
                }
                
                doubleStatusCollection.append(indexPath.row)
            }
            


            
            collectionView.reloadItems(at: [indexPath])
        }else
        {
            let vc  = CnBrowsePicture()
            let result = IsPictureDoublePicker ? [PHAsset]() : [fr[indexPath.row]]
            vc.fetchResult = result
            self.cnViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func seeBigImageView(_ img : UIImage ,_ original : CGRect,_ showView : UIView) {
        
        let backGroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height))
        backGroundView.backgroundColor = UIColor.black
        backGroundView.alpha = 0
        
        let imageView = UIImageView(frame: original)
        imageView.image = img
        imageView.tag = ToViewLargerImgTAG
        backGroundView.addSubview(imageView)
        UIApplication.shared.keyWindow?.addSubview(backGroundView)
        
        UIView.animate(withDuration: 0.3, animations: {
            let y, width, height : CGFloat?
            y = (UIScreen.main.bounds.size.height - img.size.height * UIScreen.main.bounds.size.width / img.size.width) * 0.5
            width = UIScreen.main.bounds.size.width
            height = img.size.height * UIScreen.main.bounds.size.width / img.size.width
            imageView.frame = CGRect(x: 0, y: y!, width: width!, height: height!)
            backGroundView.alpha = 1
        }) { (finish) in
            showView.alpha = 1
            backGroundView.removeFromSuperview()
        }
    }
}


// MARK: - KVC
extension CnPhotoList{
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            let offset = mycollectionView.contentSize.height - mycollectionView.bounds.size.height
            if !isScrollBottom  {
                if offset > 0 {
                    isScrollBottom = true
                    mycollectionView.setContentOffset( CGPoint(x: 0, y: offset), animated: false)
                }
            }
        }
    }
}

private let bundlePath = Bundle.main.path(forResource: "CnPhoto", ofType: "bundle")

// MARK: - NewClass
fileprivate class CnPhotoListCell: UICollectionViewCell {
    
    var aIndexPath : IndexPath?
    var fetchResult : PHFetchResult<PHAsset>?
    
    
    fileprivate lazy var myImageView = UIImageView()
    
    fileprivate lazy var myImage = UIImage()
    
    fileprivate lazy var hookImgView = UIImageView()
    
    fileprivate lazy var selectImageName = UserDefaults.standard.string(forKey: cnselectImageKey)
    fileprivate lazy var defaultImgName = UserDefaults.standard.string(forKey: cnDefaultImgKey)
    
    var doubleStatusCollection : [Int]?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        print(CnPhotoBundle.CnPhotoImageWithName("cnPhotoDefault"))
        
        
        myImageView.frame = self.bounds
        myImageView.contentMode = .scaleAspectFill
        contentView.addSubview(myImageView)
        myImageView.clipsToBounds = true
        
        if UserDefaults.standard.bool(forKey: cnIsDoublePickerKey) {
            hookImgView.frame = CGRect(x: photoListImgW - 23, y: 3, width: 20, height: 20)
            hookImgView.backgroundColor = UIColor.clear
            hookImgView.image = UIImage(contentsOfFile: bundlePath?.appending("/≈") ?? "")
            contentView.addSubview(hookImgView)
            hookImgView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func reloadData() {
        guard let fetchResult = fetchResult  else { return }
        guard let aIndexPath = aIndexPath  else { return }
        
        CnRequestManager.getListImage(fetchResult[aIndexPath.row]) {[weak self] (img) in
            self?.myImage = img
            self?.myImageView.image = img
        }
    }
    
    fileprivate func reloadHook(){
        
        guard let index = aIndexPath else { return }
        
        
        if UserDefaults.standard.bool(forKey: cnIsDoublePickerKey) {
            let isContains = doubleStatusCollection?.contains(index.row)
            
            if selectImageName == nil && defaultImgName == nil {
                if  isContains == true {
                    hookImgView.image = UIImage(contentsOfFile: bundlePath?.appending("/cnPhotoSelect") ?? "")
                }else{
                    hookImgView.image =  UIImage(contentsOfFile: bundlePath?.appending("/cnPhotoDefault") ?? "")
                }
            }else{
                if  isContains == true {
                    hookImgView.image = UIImage(named: selectImageName ?? "")
                }else{
                    hookImgView.image = UIImage(named: defaultImgName ?? "")
                }
            }
        }
    }
}

fileprivate extension CnPhotoListCell {
    
    func thumbnailWithImageWithoutScale(_ image:UIImage,_ size:CGSize) -> UIImage {
        
        var w : CGFloat = 0
        var h : CGFloat = 0
        
        if image.size.width < image.size.height{
            //固定宽
            w = size.width
            h = w  * image.size.height / image.size.width
        }
        else{
            //固定高
            h = size.height
            w = h  * image.size.width / image.size.height
        }
        
        UIGraphicsBeginImageContext(CGSize(width: w, height: h))
        image.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
        
    }
}







