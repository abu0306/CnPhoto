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

class CnBrowsePicture: UIViewController {
    
    var aindexPath : IndexPath?
    
    /// 图片对象集
    var fetchResult : [PHAsset]?{
        didSet{
            mycollectionView.reloadData()
        }
    }
    
    var doubleStatusCollection : [Int]?
    
    
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
        let cv = UICollectionView(frame: CGRect.init(x: 0,
                                                     y: 0,
                                                     width: cnScreenW + 10,
                                                     height: cnScreenH), collectionViewLayout: layout)
        cv.isPagingEnabled = true
        return cv
    }()
    
    // 是否为多选 ,默认单选
    fileprivate lazy var isPictureDoublePicker =  {
        return UserDefaults.standard.bool(forKey: cnIsDoublePickerKey)
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
            singlePickerImgViewUI()
        }else{
            singlePickerImgViewUI()
            
            let topV = UIView(frame: CGRect(x: 0, y: (cnScreenH - cnScreenW) / 2.0, width: cnScreenW, height: 1))
            topV.backgroundColor = UIColor.white
            view.addSubview(topV)
            
            let bottomV = UIView(frame: CGRect(x: 0, y: (cnScreenH - cnScreenW) / 2.0 + cnScreenW, width: cnScreenW, height: 1))
            bottomV.backgroundColor = UIColor.white
            view.addSubview(bottomV)
        }
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
                        //                        fatalError("\n****************请在Info.plist文件中设置key : View controller-based status bar appearance value : YES**************\n")
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
            
            if isPictureDoublePicker {
                /***********************多选******************************/
                var localResult = [PHAsset]()
                guard let doubleStatusCollection = doubleStatusCollection else {  return  }
                for (inex,_) in doubleStatusCollection.enumerated() {
                    guard let fr = fetchResult?[inex]  else {break}
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
                return
            }
            /***********************单选******************************/
            
            if (delegate?.responds(to: #selector(CnPhotoProtocol.completeSinglePicture(_:_:)))) ?? false {
                
                guard let scrollView = (self.mycollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CnBrowsePicturesCell)?.myscrollView else { return }
                
                guard let clipImage = scrollView.imageV.image else { return }
                
                //imgView缩放比例
                
                let scaleImage = clipImage.imageCompressWithSimple(CGSize(width: scrollView.imageV.frame.size.width , height: scrollView.imageV.frame.size.height))
                
                let imgs = scaleImage.clipWithImageRect(CGRect(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y, width: cnScreenW, height: cnScreenW ))
                
                delegate?.completeSinglePicture!(imgs, {
                    self.dismiss(animated: true, completion: nil)
                })
                return
                
            }else{
                
                if (delegate?.responds(to: #selector(CnPhotoProtocol.completeSinglePicture(_:)))) ?? false {
                    
                    guard let scrollView = (self.mycollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CnBrowsePicturesCell)?.myscrollView else { return }
                    
                    guard let clipImage = scrollView.imageV.image else { return }
                    
                    //imgView缩放比例
                    
                    let scaleImage = clipImage.imageCompressWithSimple(CGSize(width: scrollView.imageV.frame.size.width , height: scrollView.imageV.frame.size.height))
                    
                    let imgs = scaleImage.clipWithImageRect(CGRect(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y, width: cnScreenW, height: cnScreenW ))
                    delegate?.completeSinglePicture!(imgs)
                    self.dismiss(animated: true, completion: nil)
                    
                    return
                    
                }else{
                    fatalError("没有实现_CnPhotoProtocol协议")
                }
            }
            break
        default:
            break
        }
    }
}


class CnBrowseScrollView : UIScrollView,UIScrollViewDelegate,CnPrivateProtocol {
    
    var isDouble = false
    
    var currentOffSetY : CGFloat = 0
    
    /// 浏览图
    var browseImage : UIImage?{
        didSet{
            guard let strongBrowseImage = browseImage else { return }
            
            let isDoublePickerKey = UserDefaults.standard.bool(forKey: cnIsDoublePickerKey)
            
            if !isDoublePickerKey{
                //／ 原始高值
                let imgH = cnScreenW * strongBrowseImage.size.height / strongBrowseImage.size.width
                /// 差值
                let diffValue = imgH - cnScreenW
                if diffValue > 0{
                    self.contentSize = CGSize(width: self.contentSize.width, height: cnScreenH + diffValue)
                    self.setContentOffset(CGPoint(x: self.contentOffset.x, y: (imgH  - cnScreenW ) / 2.0), animated: false)
                    
                    imageV.center = CGPoint(x: self.center.x, y: cnScreenH / 2.0 + diffValue / 2.0)
                    
                    imageV.bounds = CGRect(x: 0, y: 0, width: cnScreenW, height: imgH)
                }else{
                    
                    self.contentSize = CGSize(width: self.contentSize.width, height: cnScreenH)
                    self.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                    
                    imageV.center = CGPoint(x: self.center.x, y: cnScreenH / 2.0 )
                    
                    imageV.bounds = CGRect(x: 0, y: 0, width: cnScreenW, height: imgH)
                }
            }else{
                //多选
                let imgH = cnScreenW * strongBrowseImage.size.height / strongBrowseImage.size.width
                self.contentSize = CGSize(width: self.contentSize.width, height: cnScreenH)
                imageV.center = CGPoint(x: self.center.x, y: cnScreenH / 2.0 )
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
        
        let isDoublePickerKey = UserDefaults.standard.bool(forKey: cnIsDoublePickerKey)
        
        if !isDoublePickerKey{
            
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
            
        }
        
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
    
    
    @objc func singleTapGestureRecongizer(_ recognizer:UITapGestureRecognizer) {
        
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


