//
//  AlphaPieLineTextLayerAnimator.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public struct AlphaPieLineTextLayerAnimator: PieLineTextLayerAnimator {
    
    public var duration: TimeInterval = 0.3
    
    public func animate(_ layer: CALayer) {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = duration
        layer.add(anim, forKey: "alphaAnim")
    }
    
    public func animate(_ label: UILabel) {
        label.alpha = 0
        UIView.animate(withDuration: duration) {
            label.alpha = 1
        }
    }
}
