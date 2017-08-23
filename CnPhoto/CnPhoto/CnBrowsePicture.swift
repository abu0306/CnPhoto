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

@objc protocol CnPhotoProtocol:NSObjectProtocol{
    //双击回调
    @objc optional func handleDoubleTap(_ point:CGPoint)
}

class CnBrowsePicture: UIViewController {
    
    /// 图片对象集
    var fetchResult : PHFetchResult<PHAsset>?{
        didSet{
            mycollectionView.reloadData()
        }
    }
    
    lazy var navigationView: UIView = {
        let v = UIView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: cnScreenW,
                                                 height: 64))
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.black
        mycollectionView.delegate = self
        mycollectionView.dataSource = self
        view.addSubview(mycollectionView)
        mycollectionView.register(CnBrowsePicturesCell.classForCoder(), forCellWithReuseIdentifier: cellID)
        
        
        let backbtn = UIButton(type: .custom)
        backbtn.frame = CGRect(x: 0, y: 20, width: 44, height: 60)
        backbtn.setTitle("返回", for: .normal)
        backbtn.setTitleColor(UIColor.white, for: .normal)
        backbtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        navigationView.addSubview(backbtn)
        
        view.addSubview(navigationView)

    }
    
    
    @objc fileprivate func backBtnAction() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.setStatusBarHidden(true, with: .none)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.setStatusBarHidden(false, with: .none)
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

