//
//  CnBrowsePictures.swift
//  CnPhoto
//
//  Created by MyLifeIsNotLost on 2017/8/9.
//  Copyright © 2017年 MyLifeIsNotLost. All rights reserved.
//

import UIKit
import Photos

class CnBrowseScrollView : UIScrollView,UIScrollViewDelegate,CnPrivateProtocol {
    
    var isDouble = false
    
    var currentOffSetY : CGFloat = 0
    
    /// 浏览图
    var browseImage : UIImage?{
        didSet{
            guard let strongBrowseImage = browseImage else { return }
            
            //／ 原始高值
            let imgH = cnScreenW * strongBrowseImage.size.height / strongBrowseImage.size.width
            /// 差值
            let diffValue = imgH - cnScreenW
            if diffValue > 0{
                self.contentSize = CGSize(width: self.contentSize.width, height: cnScreenH + diffValue)
                self.setContentOffset(CGPoint(x: self.contentOffset.x, y: (imgH  - cnScreenW ) / 2.0), animated: false)
                
                imageV.center = CGPoint(x: self.center.x, y: cnScreenH / 2.0 + diffValue / 2.0)
                
                imageV.bounds = CGRect(x: 0, y: 0, width: cnScreenW, height: imgH)
            }
            imageV.image = browseImage
        }
    }
    
    lazy var imageV: CnBrowseImageView = {
        let v = CnBrowseImageView(frame: CGRect.zero)
        
        v.isUserInteractionEnabled = true
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    /// 单击隐藏
    internal func handleSingleTap() {
        
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
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        currentOffSetY = scrollView.contentOffset.y
    }
    
    /// 控制缩放是在中心
    ///
    /// - Parameter scrollView: 使得imageView居中
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX : CGFloat = (self.bounds.size.width > self.contentSize.width) ? ((self.bounds.size.width - self.contentSize.width) * 0.5) : 0
        let offsetY : CGFloat = (self.bounds.size.height > self.contentSize.height) ? ((self.bounds.size.height - self.contentSize.height) * 0.5) : 0.0
        
        imageV.center = CGPoint(x: self.contentSize.width * 0.5 + offsetX, y: self.contentSize.height * 0.5 + offsetY)
        
        let differenceValue = imageV.frame.size.height - cnScreenW
        let imgH = imageV.frame.size.height
        if differenceValue > 0{
            if imgH > cnScreenH {
                self.contentSize = CGSize(width: self.contentSize.width, height: cnScreenH + (imgH  - cnScreenW ))
                
                self.setContentOffset(CGPoint(x: self.contentOffset.x, y: (imgH  - cnScreenW ) / 2.0), animated: false)
                imageV.center = CGPoint(x: imageV.center.x, y:cnScreenH / 2.0 + (imgH  - cnScreenW ) / 2.0)
                
            }else{
                self.contentSize = CGSize(width: self.contentSize.width, height: cnScreenH + (imgH  - cnScreenW ))
                self.setContentOffset(CGPoint(x: self.contentOffset.x, y: (imgH  - cnScreenW ) / 2.0), animated: false)
                imageV.center = CGPoint(x: imageV.center.x, y: cnScreenH / 2.0 + (imgH  - cnScreenW ) / 2.0)
            }
        }
        else{
            print(imageV.frame.size)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
                
    }

}
class CnBrowsePicturesCell: UICollectionViewCell {
    
    var myscrollView : CnBrowseScrollView?
    
    var aindexPath : IndexPath?
    var fetchResult : [PHAsset]?
    
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


class CnBrowseImageView: UIImageView,UIGestureRecognizerDelegate {
    
    weak var delegate : CnPrivateProtocol?
    
    private  lazy var singleTap = UITapGestureRecognizer()
    private  lazy var doubleTap = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        singleTap.numberOfTapsRequired = 1
        singleTap.addTarget(self, action: #selector(singleTapGestureRecongizer(_:)))
        addGestureRecognizer(singleTap)
        
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(singleTapGestureRecongizer(_:)))
        doubleTap.delegate = self
        addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func singleTapGestureRecongizer(_ recognizer:UITapGestureRecognizer) {
        
        if recognizer.state == .ended {
            switch recognizer.numberOfTapsRequired {
            case 1:
                handleSingleTap()
                break
            case 2:
                handleDoubleTap(recognizer.location(in: self))
                break
            default:
                break
            }
        }
    }
    
    private func handleSingleTap(){
        if self.delegate?.responds(to: #selector(CnPrivateProtocol.handleSingleTap)) ?? false {
            self.delegate?.handleSingleTap!()
        }else{
            fatalError("*******没有实现单击协议*******")
        }
    }
    
    private func handleDoubleTap(_ point:CGPoint) {
        if (self.delegate?.responds(to: #selector(CnPrivateProtocol.handleDoubleTap(_:)))) ?? false{
            self.delegate?.handleDoubleTap!(point)
        }else{
            fatalError("*******没有实现双击协议*******")
        }
    }
    
    func gesture(_ recognizer:UIGestureRecognizer) {
        
        recognizer.location(in: self)
        
    }
    
}
