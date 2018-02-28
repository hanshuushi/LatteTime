<p align="center">
LatteTime
</p>

<p align="center">
<a href="https://cocoapods.org/pods/LatteTime"> <img src="https://img.shields.io/cocoapods/v/LatteTime.svg?style=flat"></a>
<a href="https://github.com/hanshuushi/LatteTime/blob/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/LatteTime.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/LatteTime"><img src="https://img.shields.io/cocoapods/p/LatteTime.svg?style=flat"></a>
</p>

LatteTime 可用于网络加载时候的Loading动画，通过便捷的方式能够快速展现生动与众不同的加载效果，并且可以自定义许多参数来达到自己想要的效果。

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingView = LatteTime()
        
        self.view.addSubview(loadingView)
        
        loadingView.play()
}
```