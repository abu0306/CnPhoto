## CnPhoto
###CnPhoto 基于系统Photo框架开发,适用于iOS8.0以后版本
---
##Installation
---
CnPhoto supports multiple methods for installing the library in a project.
###Installation with CocoaPods
---
###Podfile
1,To integrate CnPhoto into your Xcode project using CocoaPods, specify it in your Podfile:

```python
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
##Usage
The default navigation album:
```python
/// 相册默认导航
//self.photoAlbum(false)
```
Custom navigation photo album:
```python
//相册自定义导航
self.photoAlbum(
 false,
 .lightContent,
 UIColor.black,
 tintColor: UIColor.white,
 bgColor: UIColor.white
  )

```

 🎉  🎉  🎉  🎉  🎉  🎉  🎉  🎉  🎉   🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍
