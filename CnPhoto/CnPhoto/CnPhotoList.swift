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
    
    /// 图片对象
    var assetCollection : PHAssetCollection?
    
    /// 图片对象集
    fileprivate var fetchResult : PHFetchResult<PHAsset>?
    
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
    
    
    /// 获取图片集合
    ///
    /// - Parameter asset: 图片对象
    func getFetchResult(_ asset:PHAssetCollection?) {
        guard let asset = asset else { return }
        fetchResult = PHAsset.fetchAssets(in: asset, options: nil)
        mycollectionView.reloadData()
    }
    
    func setupUI(){
        mycollectionView.frame = UIScreen.main.bounds
        mycollectionView.delegate = self
        mycollectionView.dataSource = self
        mycollectionView.alwaysBounceVertical = true
        addSubview(mycollectionView)
        
        //单元格注册
        mycollectionView.register(CnPhotoListCell.classForCoder(), forCellWithReuseIdentifier: cellID)
    }
    
}

extension CnPhotoList:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = fetchResult?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CnPhotoListCell
        cell?.aIndexPath = indexPath
        cell?.fetchResult = fetchResult
        cell?.reloadData()
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("\(indexPath)")
        
        let cell = collectionView.cellForItem(at: indexPath) as? CnPhotoListCell
        
        
//        let _ = cell?.convert((cell?.myImageView.frame)!, to: UIApplication.shared.keyWindow)
        
        let v  = CnBrowsePictures()
        
        CnRequestManager.browsePictures(fetchResult?[indexPath.row]) { (img) in
            
            

        
        }
        
        v.imageV.image = cell?.myImageView.image
        addSubview(v)
        
    }
}

class CnPhotoListCell: UICollectionViewCell {
    
    
    var aIndexPath : IndexPath?
    var fetchResult : PHFetchResult<PHAsset>?
    
    lazy var myImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        myImageView.frame = self.bounds
        myImageView.contentMode = .scaleAspectFill
        addSubview(myImageView)
        backgroundColor = UIColor.yellow
        myImageView.layer.masksToBounds = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        guard let fetchResult = fetchResult  else { return }
        guard let aIndexPath = aIndexPath  else { return }
        
        CnRequestManager.getListImage(fetchResult[aIndexPath.row]) {[weak self] (img) in
            print(img.size)
            self?.myImageView.image = img
            //                        self?.myImageView.image = self?.thumbnailWithImageWithoutScale(img, CGSize(width: photoListImgW, height: photoListImgW))
        }
    }
}

extension CnPhotoListCell {
    
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
