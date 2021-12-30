//
//  AlphaPieViewLayerAnimator.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

/// Adds alpha animation to view
public struct AlphaPieViewLayerAnimator: PieViewLayerAnimator {
    
    public var duration: TimeInterval = 0.3
    
    public func animate(_ view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: duration) {
            view.alpha = 1
        }
    }
}
