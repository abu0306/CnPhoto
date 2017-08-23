//
//  CnBrowsePictures.swift
//  CnPhoto
//
//  Created by MyLifeIsNotLost on 2017/8/9.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//





import UIKit
import Photos
//@objc protocol CnPhotoProtocol:NSObjectProtocol{
//    //双击回调
//    @objc optional func handleDoubleTap(_ point:CGPoint)
//}

//private let cellID = "CnBrowsePicturesCell"
//
//class CnBrowsePictures: UIView {
//    
//    /// 图片对象集
//    var fetchResult : PHFetchResult<PHAsset>?{
//        didSet{
//            mycollectionView.reloadData()
//        }
//    }
//    
//    lazy var mycollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: cnScreenW + 10, height: cnScreenH)
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing = 0;
//        let cv = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: cnScreenW + 10, height: cnScreenH), collectionViewLayout: layout)
//        cv.isPagingEnabled = true
//        return cv
//    }()
//    
//    
//    private override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.frame = UIScreen.main.bounds
//        self.backgroundColor = UIColor.black
//        
//        mycollectionView.delegate = self
//        mycollectionView.dataSource = self
//        addSubview(mycollectionView)
//        
//        mycollectionView.register(CnBrowsePicturesCell.classForCoder(), forCellWithReuseIdentifier: cellID)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension CnBrowsePictures:UICollectionViewDelegate,UICollectionViewDataSource{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let count = fetchResult?.count else {  return 0 }
//        return count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CnBrowsePicturesCell
//        
//        cell?.aindexPath = indexPath
//        cell?.fetchResult = fetchResult
//        cell?.reloadUI()
//        
//        return cell!
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        
//        for v in cell.contentView.subviews {
//            if let scrollView = v as? CnBrowseScrollView {
//                scrollView.isDouble = false
//                scrollView.setZoomScale(1, animated: false)
//                break
//            }
//        }
//    }
//    
//}

class CnBrowseScrollView : UIScrollView,UIScrollViewDelegate,CnPhotoProtocol {
    
    var isDouble = false
    
    
    /// 浏览图
    var browseImage : UIImage?{
        didSet{
            guard let strongBrowseImage = browseImage else { return }
            imageV.image = browseImage
            
            imageV.center = self.center
            imageV.bounds = CGRect(x: 0, y: 0, width: cnScreenW, height: cnScreenW * strongBrowseImage.size.height / strongBrowseImage.size.width)
            
        }
    }
    
    lazy var imageV: CnBrowseImageView = {
        let v = CnBrowseImageView()
        v.isUserInteractionEnabled = true
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear

        imageV.delegate = self
        addSubview(imageV)
        
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrollEnabled = true
    }
    
    //双击缩放
    func handleDoubleTap(_ point: CGPoint) {
        
        if !isDouble {
            isDouble = true
            
            let newZoomScale:CGFloat = (self.maximumZoomScale + self.minimumZoomScale) / 2.0
            let xsize:CGFloat = self.bounds.size.width / newZoomScale
            let ysize:CGFloat = self.bounds.size.height / newZoomScale
            self.zoom(to:CGRect(x: point.x - xsize / 2.0 , y: point.y - ysize / 2.0, width: xsize, height: ysize) , animated: true)
            
            return
        }
        
        if (self.zoomScale != self.minimumZoomScale ) {
            
            self.setZoomScale(minimumZoomScale, animated: true)
        }else
        {
            let newZoomScale:CGFloat = (self.maximumZoomScale + self.minimumZoomScale) / 2.0
            let xsize:CGFloat = self.bounds.size.width / newZoomScale
            let ysize:CGFloat = self.bounds.size.height / newZoomScale
            self.zoom(to:CGRect(x: point.x - xsize / 2.0 , y: point.y - ysize / 2.0, width: xsize, height: ysize) , animated: true)
        }
    }
    
    /// 控制缩放是在中心
    ///
    /// - Parameter scrollView: 使得imageView居中
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX : CGFloat = (self.bounds.size.width > self.contentSize.width) ? ((self.bounds.size.width - self.contentSize.width) * 0.5) : 0
        let offsetY : CGFloat = (self.bounds.size.height > self.contentSize.height) ? ((self.bounds.size.height - self.contentSize.height) * 0.5) : 0.0
        imageV.center = CGPoint(x: self.contentSize.width * 0.5 + offsetX, y: self.contentSize.height * 0.5 + offsetY)
    }
}


class CnBrowsePicturesCell: UICollectionViewCell {
    
    var myscrollView : CnBrowseScrollView?
    
    var aindexPath : IndexPath?
    var fetchResult : PHFetchResult<PHAsset>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        
        myscrollView = CnBrowseScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width - 10, height: frame.size.height))
        guard let myscrollView = myscrollView else { return  }
        myscrollView.contentSize = myscrollView.bounds.size
        contentView.addSubview(myscrollView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI() {
        guard let fetchResult = fetchResult else { return }
        guard let aindexPath = aindexPath else { return }
        let asset = fetchResult[aindexPath.row]
        CnRequestManager.browsePictures(asset) {[weak self] (image) in
            self?.myscrollView?.browseImage = image
        }
    }
}


class CnBrowseImageView: UIImageView {
    
    weak var delegate : CnPhotoProtocol?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        switch touch.tapCount {
        case 0:
            break
        case 1:
            print("敲击一下")
            break
        case 2:
            //两下
            print("敲击两下")
            handleDoubleTap(touch)
            break
        default:
            break
        }
        self.next?.touchesBegan(touches, with: event)
    }
    
    func handleDoubleTap(_ touch:UITouch) {
        if (self.delegate?.responds(to: #selector(CnPhotoProtocol.handleDoubleTap(_:)))) ?? false{
            self.delegate?.handleDoubleTap!(touch.location(in: self))
        }else{
            fatalError("*******没有实现双击协议*******")
        }
    }
    
    func gesture(_ recognizer:UIGestureRecognizer) {
        
        recognizer.location(in: self)
        
    }
    
}
