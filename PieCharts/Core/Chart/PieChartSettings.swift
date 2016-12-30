//
//  PieChartSettings.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public struct PieChartSettings {
    
    public var innerRadius: CGFloat = 50
    public var outerRadius: CGFloat = 100
    public var referenceAngle: CGFloat = CGFloat.pi * 3 / 2 // Top center
    public var selectedOffset: CGFloat = 30
    
    public init() {}
}
