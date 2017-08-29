
 ![](http://upload-images.jianshu.io/upload_images/5874642-f0d20e6e207fb512.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 ---
## CnPhoto
---
CnPhoto 基于系统Photo框架开发,适用于iOS8.0以后版本
---
Installation
---
CnPhoto supports multiple methods for installing the library in a project.
Installation with CocoaPods
---
Podfile
1,To integrate CnPhoto into your Xcode project using CocoaPods, specify it in your Podfile:

```swift
platform :ios, '8.0'
use_frameworks!

target 'TargetName' do
pod 'CnPhoto'
end
```
Then, run the following command:

```python
$ pod install
```

2,Direct download package, to join the project, don't need any dependent libraries

---
Usage
The default navigation album:
单选相册:
```swift
/// 单选相册默认导航
//self.photoAlbum(false)

//单选相册自定义导航
self.photoAlbum(false, .lightContent, UIColor.black, tintColor: UIColor.white, bgColor: UIColor.white)

```
多选相册:
```swift
/// 多选相册默认导航
//self.photoAlbum(true)

//多选相册自定义导航
self.photoAlbum(true, .lightContent, UIColor.black, tintColor: UIColor.white, bgColor: UIColor.white)

```

相册回调:
```swift
//    /// UIImage异步回调
//    ///
//    /// - Parameter img: _
//    func completeSinglePicture(_ img: UIImage) {
//        myImageView.image = img
//    }

    /// UIImage同步回调
    ///
    /// - Parameters:
    ///   - img: _
    ///   - completeHandle: 回调控制
    func completeSinglePicture(_ img: UIImage, _ completeHandle: () -> ()) {
        myImageView.image = img
        completeHandle()
    }

    /// [UIImage]多选相册自定义导航异步回调
    ///
    /// - Parameter imgArray: _
//    func completeDoublePicture(_ imgArray: [UIImage]) {
//        myImageView.image = imgArray[0]
//        print(imgArray)
//    }

    /// [UIImage]多选相册自定义导航同步回调
    ///
    func completeSynchronousDoublePicture(_ imgArray: [UIImage], _ completeHandle: () -> ()) {

        myImageView.image = imgArray[0]
        print(imgArray)
        completeHandle()
    }
```

 🎉  🎉  🎉  🎉  🎉  🎉  🎉  🎉  🎉   🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍
