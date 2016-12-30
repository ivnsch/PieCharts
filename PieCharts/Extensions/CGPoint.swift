//
//  CGPoint.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func distance(p: CGPoint) -> CGFloat {
        let xDistance = (p.x - x)
        let yDistance = (p.y - y)
        return sqrt((xDistance * xDistance) + (yDistance * yDistance))
    }
}
