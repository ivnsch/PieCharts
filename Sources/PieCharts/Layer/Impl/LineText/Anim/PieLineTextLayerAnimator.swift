//
//  PieLineTextLayerAnimator.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public protocol PieLineTextLayerAnimator {
    
    func animate(_ layer: CALayer)
    
    func animate(_ label: UILabel)
}
