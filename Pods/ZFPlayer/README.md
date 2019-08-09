
<p align="center">
<img src="https://upload-images.jianshu.io/upload_images/635942-092427e571756309.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" alt="ZFPlayer" title="ZFPlayer" width="557"/>
</p>

<p align="center">
<a href="https://img.shields.io/cocoapods/v/ZFPlayer.svg"><img src="https://img.shields.io/cocoapods/v/ZFPlayer.svg"></a>
<a href="https://img.shields.io/github/license/renzifeng/ZFPlayer.svg?style=flat"><img src="https://img.shields.io/github/license/renzifeng/ZFPlayer.svg?style=flat"></a>
<a href="https://img.shields.io/cocoapods/dt/ZFPlayer.svg?maxAge=2592000"><img src="https://img.shields.io/cocoapods/dt/ZFPlayer.svg?maxAge=2592000"></a>
<a href="https://img.shields.io/cocoapods/at/ZFPlayer.svg?maxAge=2592000"><img src="https://img.shields.io/cocoapods/at/ZFPlayer.svg?maxAge=2592000"></a>
<a href="http://cocoadocs.org/docsets/ZFPlayer"><img src="https://img.shields.io/cocoapods/p/ZFPlayer.svg?style=flat"></a>
<a href="http://weibo.com/zifeng1300"><img src="https://img.shields.io/badge/weibo-@%E4%BB%BB%E5%AD%90%E4%B8%B0-yellow.svg?style=flat"></a>
</p>

[中文说明](https://www.jianshu.com/p/90e55deb4d51)

Before this, you used ZFPlayer, are you worried about encapsulating avplayer instead of using or modifying the source code to support other players, the control layer is not easy to customize, and so on? In order to solve these problems, I have wrote this player template, for player SDK you can conform the `ZFPlayerMediaPlayback` protocol, for control view you can conform the `ZFPlayerMediaControl` protocol, can custom the player and control view.

在3.X之前，是不是在烦恼播放器SDK自定义、控制层自定义等问题。作者公司多个项目分别使用不同播放器SDK以及每个项目控制层都不一样，但是为了统一管理、统一调用，我特意写了这个播放器壳子。播放器SDK只要遵守`ZFPlayerMediaPlayback`协议，控制层只要遵守`ZFPlayerMediaControl`协议，完全可以实现自定义播放器和控制层。

![ZFPlayer思维导图](https://upload-images.jianshu.io/upload_images/635942-e99d76498cb01afb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## Requirements

- iOS 7+
- Xcode 8+

## Installation

ZFPlayer is available through [CocoaPods](https://cocoapods.org). To install it,use player template simply add the following line to your Podfile:

```objc
pod 'ZFPlayer', '~> 3.0'
```

Use default controlView simply add the following line to your Podfile:

```objc
pod 'ZFPlayer/ControlView', '~> 3.0'
```
Use AVPlayer simply add the following line to your Podfile:

```objc
pod 'ZFPlayer/AVPlayer', '~> 3.0'
```
如果使用AVPlayer边下边播可以参考使用[KTVHTTPCache](https://github.com/ChangbaDevs/KTVHTTPCache)

Use ijkplayer simply add the following line to your Podfile:

```objc
pod 'ZFPlayer/ijkplayer', '~> 3.0'
```
[IJKMediaFramework SDK](https://gitee.com/renzifeng/IJKMediaFramework) support cocoapods

Use KSYMediaPlayer simply add the following line to your Podfile:

```objc
pod 'ZFPlayer/KSYMediaPlayer', '~> 3.0'
```
[KSYMediaPlayer SDK](https://github.com/ksvc/KSYMediaPlayer_iOS) support cocoapods

## Usage introduce

####  ZFPlayerController
Main classes, two initialization methods, normal mode initialization and list style initialization (tableView, collection)

Normal style initialization 

```objc
ZFPlayerController *player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:containerView];
ZFPlayerController *player = [[ZFPlayerController alloc] initwithPlayerManager:playerManager containerView:containerView];
```

List style initialization

```objc
ZFPlayerController *player = [ZFPlayerController playerWithScrollView:tableView playerManager:playerManager containerViewTag:containerViewTag];
ZFPlayerController *player = [ZFPlayerController alloc] initWithScrollView:tableView playerManager:playerManager containerViewTag:containerViewTag];
```

#### ZFPlayerMediaPlayback
For the playerMnager,you must conform `ZFPlayerMediaPlayback` protocol,custom playermanager can supports any player SDK，such as `AVPlayer`,`MPMoviePlayerController`,`ijkplayer`,`vlc`,`PLPlayerKit`,`KSYMediaPlayer`and so on，you can reference the `ZFAVPlayerManager`class.

```objc
Class<ZFPlayerMediaPlayback> *playerManager = ...;
```

#### ZFPlayerMediaControl
This class is used to display the control layer, and you must conform the ZFPlayerMediaControl protocol, you can reference the `ZFPlayerControlView` class.

```objc
UIView<ZFPlayerMediaControl> *controlView = ...;
player.controlView = controlView;
```

## Usage

#### Normal Style

```objc
/// Your custom playerManager must conform `ZFPlayerMediaPlayback` protocol.
Class<ZFPlayerMediaPlayback> *playerManager = ...;

/// playerController
ZFPlayerController *player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
player.controlView = controlView<ZFPlayerMediaControl>;
playerManager.assetURL = [NSURL URLWithString:...];
```

#### List style

```objc
/// Your custom playerManager must conform `ZFPlayerMediaPlayback` protocol.
Class<ZFPlayerMediaPlayback> *playerManager = ...;

/// playerController
ZFPlayerController *player = [ZFPlayerController playerWithScrollView:tableView playerManager:playerManager containerViewTag:tag<NSInteger>];
player.controlView = controlView<ZFPlayerMediaControl>;
self.player.assetURLs = array<NSURL *>;
```

Rotate the video the viewController must implement

```objc
- (BOOL)shouldAutorotate {
    return player.shouldAutorotate;
}
```

### Picture demonstration

![Picture effect](https://upload-images.jianshu.io/upload_images/635942-1b0e23b7f5eabd9e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## Reference

- https://github.com/Bilibili/ijkplayer
- https://github.com/changsanjiang/SJVideoPlayer

## Author

- Weibo: [@任子丰](https://weibo.com/zifeng1300)
- Email: zifeng1300@gmail.com
- QQ群: (付费群)

![](https://upload-images.jianshu.io/upload_images/635942-c20708c913c591a0.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 打赏作者

如果ZFPlayer在开发中有帮助到你、如果你需要技术支持或者你需要定制功能，都可以拼命打赏我！

![支付.jpg](https://upload-images.jianshu.io/upload_images/635942-b9b836cfbb7a5e44.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## License

ZFPlayer is available under the MIT license. See the LICENSE file for more info.

## Question

1、demo运行不了？

答：下载后本demo可以直接编译运行，不需要`pod install`，`pod install`后会出错，因为依赖其他播放器SDK较大，所以默认没有添加进来。如果你想用，那请修改`podspec`文件，具体怎么修改自己去查吧，然后再pod install。

2、为啥我podfile这样写`pod 'ZFPlayer', '~> 3.0'`和demo里不一样，缺少好多类

答：作者秉着插件化的思想来开发此开源库，首先作者的思想是提供一个播放器壳子，关于播放器的核心SDK、还有控制层是完全支持自定义的，所以默认只有Core文件夹下的代码，如果你想使用作者提供的AVPlayer、IJKPlayer等都可单独在podfile写，提供的默认控制层亦是如此，具体看上边readme吧。

3、之前是免费加群，为什么现在要付费加群？

答：之前是免费群每天找作者解决问题的太多了，作者还有自己的工作要干，为了过滤一些伸手党，所以变为付费群。群内比较活跃，作者、群友都可帮忙解决，如果你有问题都可以加群交流。你也可以扫上边的码，付款大于10元备注写上QQ号（请确保你的QQ号添加没有问题验证，不然没法添加你），作者看到后会加你然后拉你入群。



