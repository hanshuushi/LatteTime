//
//  ActivityIndicatorView.swift
//  Loading
//
//  Created by 范舟弛 on 2017/3/7.
//  Copyright © 2017年 范舟弛. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ActivityIndicatorView: UIView {
    fileprivate static let animationDuration:CFTimeInterval = 0.5
    fileprivate static let pointColor:UIColor = UIColor.red
    fileprivate static let pointDiameter:CGFloat = 10
    fileprivate static let pointJumpHeight:CGFloat = 30
    fileprivate static let pointCurvature:CGFloat = 0.4
    fileprivate static let pointPadding:CGFloat = 5
    fileprivate static let curvatureDurationRate:CGFloat = 0.5
    fileprivate static let pointTranslationLength:CGFloat = pointJumpHeight - pointDiameter * (1.0 + pointCurvature)
    
    let points:[PointLayer]
    
    init() {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: ActivityIndicatorView.ActivityIndicatorViewWidth,
                           height: ActivityIndicatorView.pointJumpHeight)
        
        var points = [PointLayer]()
        
        for i in 0..<3 {
            let pointLayer = PointLayer()
            
            pointLayer.frame = CGRect(x: 0, y: 0, width: ActivityIndicatorView.pointDiameter, height: ActivityIndicatorView.pointDiameter)
            
            switch i {
            case 0:
                pointLayer.position = CGPoint(x: ActivityIndicatorView.pointDiameter * (1.0 + ActivityIndicatorView.pointCurvature) / 2.0, y: ActivityIndicatorView.pointJumpHeight)
                pointLayer.animationProgress = 0.707106781186548 * ActivityIndicatorView.curvatureDurationRate
            case 1:
                pointLayer.position = CGPoint(x: ActivityIndicatorView.ActivityIndicatorViewWidth / 2.0, y: ActivityIndicatorView.pointJumpHeight)
                pointLayer.animationProgress = 0.0
            case 2:
                pointLayer.position = CGPoint(x: ActivityIndicatorView.ActivityIndicatorViewWidth - ActivityIndicatorView.pointDiameter * (1.0 + ActivityIndicatorView.pointCurvature) / 2.0, y: ActivityIndicatorView.pointJumpHeight)
                pointLayer.animationProgress = 0.707106781186548 * ActivityIndicatorView.curvatureDurationRate
                pointLayer.sign = -1
            default:
                break
            }
            
            
            points.append(pointLayer)
        }
        
        self.points = points
        
        super.init(frame: frame)
        
        for pointLayer in points {
            self.layer.addSublayer(pointLayer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        for pointLayer in points {
            pointLayer.timer?.isPaused = false
        }
    }
    
    func pause() {
        for pointLayer in points {
            pointLayer.timer?.isPaused = true
        }
    }
 
    fileprivate static let ActivityIndicatorViewWidth:CGFloat = ActivityIndicatorView.pointDiameter * (1.0 + ActivityIndicatorView.pointCurvature) * 3.0 + ActivityIndicatorView.pointPadding * 2.0
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: ActivityIndicatorView.ActivityIndicatorViewWidth,
                      height: ActivityIndicatorView.pointJumpHeight)
    }
    
    deinit {
        for pointLayer in points {
            pointLayer.timer?.isPaused = true
            pointLayer.timer?.invalidate()
            pointLayer.timer = nil
            pointLayer.removeFromSuperlayer()
        }
    }
}

extension ActivityIndicatorView {
    
    class PointLayer: CALayer {
        
        var timer:CADisplayLink?
        
        var sign:Int = 1
        
        override init() {
            super.init()
//
            timer = CADisplayLink(target: self,
                                  selector: #selector(PointLayer.animationTrack(displayLink:)))
            
            timer!.isPaused = true
            
            timer!.add(to: .main,
                      forMode: .commonModes)
//
            self.backgroundColor = ActivityIndicatorView.pointColor.cgColor
            
            self.cornerRadius = ActivityIndicatorView.pointDiameter / 2.0
            
            self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        deinit {
            timer?.invalidate()
        }
        
        @objc func animationTrack(displayLink:CADisplayLink) {
            if displayLink != timer {
                return
            }
            
            let timeRate = displayLink.duration / ActivityIndicatorView.animationDuration
            
            let targetProgress = self.animationProgress + CGFloat(sign) * CGFloat(timeRate)
            
            if targetProgress > 1.0 {
                sign = -1
                
                let offset = targetProgress - 1.0
                
                self.animationProgress = 1.0 - offset
            } else if targetProgress < 0.0 {
                sign = 1
                
                self.animationProgress = -targetProgress
            } else {
                self.animationProgress = targetProgress
            }
        }
        
        override init(layer: Any) {
            super.init(layer: layer)
            
            self.backgroundColor = UIColor.blue.cgColor
            
            self.cornerRadius = ActivityIndicatorView.pointDiameter / 2.0
            
            self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var animationProgress:CGFloat {
            set {
                _animationProgress = max(0.0, min(1.0, newValue))
                
                if _animationProgress >= ActivityIndicatorView.curvatureDurationRate {
                    var rate = (_animationProgress - ActivityIndicatorView.curvatureDurationRate) / (1.0 - ActivityIndicatorView.curvatureDurationRate)
                    
                    rate = PointLayer.mgEaseOutQuad(t: rate)
                    
                    let length = ActivityIndicatorView.pointTranslationLength * rate
                    
                    let transform = CATransform3DMakeTranslation(0, -length, 0)
                    
                    CATransaction.begin()
                    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                    
                    self.transform = CATransform3DScale(transform, 1.0 - ActivityIndicatorView.pointCurvature, 1.0 + ActivityIndicatorView.pointCurvature, 1.0)
                    
                    CATransaction.commit()
                } else {
                    var rate = _animationProgress / ActivityIndicatorView.curvatureDurationRate
                    
                    rate = PointLayer.mgEaseInQuad(t: rate)
                    
                    let scaleX = 1.0 + ActivityIndicatorView.pointCurvature - ActivityIndicatorView.pointCurvature * 2.0 * rate
                    
                    let scaleY = 1.0 - ActivityIndicatorView.pointCurvature + ActivityIndicatorView.pointCurvature * 2.0 * rate
                    
                    CATransaction.begin()
                    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                    
                    self.transform = CATransform3DMakeScale(scaleX, scaleY, 1.0)
                    
                    CATransaction.commit()
                }
            }
            get {
                return _animationProgress
            }
        }
        
        static fileprivate func mgEaseInQuad(t:CGFloat , b:CGFloat = 0, c:CGFloat = 1.0) -> CGFloat {
            return c*t*t + b;
        }
        
        static fileprivate func mgEaseOutQuad(t:CGFloat , b:CGFloat = 0, c:CGFloat = 1.0) -> CGFloat {
            return -c*t*(t-2) + b;
        }
        
        var _animationProgress:CGFloat = 0
    }
}
