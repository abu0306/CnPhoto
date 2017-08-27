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
        return UserDefaults.standard.bool(forKey: isDoublePickerKey)
    }()
    
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
        setupUI()
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
    
    fileprivate func setupUI(){
        mycollectionView.backgroundColor = UIColor.clear
        mycollectionView.frame = UIScreen.main.bounds
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
        cell?.reloadData()
        return cell!
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc  = CnBrowsePicture()
        guard let fr = fetchResult else {
            fatalError("*********没有获取到图像集*********")
        }
        
        let result = IsPictureDoublePicker ? [PHAsset]() : [fr[indexPath.row]]
        vc.fetchResult = result
        self.cnViewController()?.navigationController?.pushViewController(vc, animated: true)
        
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

// MARK: - NewClass
fileprivate class CnPhotoListCell: UICollectionViewCell {
    
    var aIndexPath : IndexPath?
    var fetchResult : PHFetchResult<PHAsset>?
    
    var myImage : UIImage?
    
    fileprivate lazy var myImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        myImageView.frame = self.bounds
        myImageView.contentMode = .scaleAspectFill
        contentView.addSubview(myImageView)
        myImageView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        guard let fetchResult = fetchResult  else { return }
        guard let aIndexPath = aIndexPath  else { return }
        
        CnRequestManager.getListImage(fetchResult[aIndexPath.row]) {[weak self] (img) in
            self?.myImage = img
            self?.myImageView.image = img
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







