<img src="https://github.com/hanshuushi/LatteTime/blob/0.9.0/Demo.gif?raw=true" alt="LatteTime" title="LatteTime" width="171"/>

[![Platform](https://img.shields.io/cocoapods/p/LatteTime.svg?style=flat)](https://cocoapods.org/pods/LatteTime)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/LatteTime.svg?style=flat)](https://cocoapods.org/pods/LatteTime)

LatteTime 可用于网络加载时候的Loading动画，通过便捷的方式能够快速展现生动与众不同的加载效果，并且可以自定义许多参数来达到自己想要的效果。

```swift
	override func viewDidLoad() {
		super.viewDidLoad()
        
		let loadingView = LatteTime()
        
		self.view.addSubview(loadingView)
        
		loadingView.play()
	}
```

## 功能
- 可在viewDidLoad或者其他自定义View的初始化时中直接添加。
- AutoLayout可自动调整大小，不需要设定。
- 能够控制动画单次循环时长、跳跃高度、颜色、落地变形程度等参数，可实时转化。
- 通过CADisplayLink的方式控制动画，避免如CAAnimation在从后台返回时动画停车。

## 需要
- iOS 8.0+
- Swift 4

## 安装
### CocoaPods
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'LatteTime', '~> 0.9.0'
end
```

## 参数说明
### LatteTime.defaultStyle
可在AppDelegate获其他方式启动时，来配置LatteTime的配置，在之后的初始化中会启用这项配置、
```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        LatteTime.defaultStyle.pointColor = UIColor.blue
        
        return true
    }
```

### LatteTimeStyle.animationDuration
用于控制小球单次掉落或者升级的时长

### LatteTimeStyle.pointColor
小球的颜色

### pointDiameter
小球的直径

### pointJumpHeight
小球的跳跃高度

### pointCurvature
小球变形的程度 0.0 - 1.0之间

### pointPadding
小球的间距
