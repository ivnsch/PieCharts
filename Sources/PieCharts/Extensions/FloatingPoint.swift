//
//  FloatingPoint.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 05/01/2017.
//  Copyright © 2017 Ivan Schuetz. All rights reserved.
//

import Foundation

extension FloatingPoint {
    
    var degreesToRadians: Self {
        return self * .pi / 180
    }
    
    var radiansToDegrees: Self {
        return self * 180 / .pi
    }
    
    func truncate(_ fractions: Self) -> Self {
        return Darwin.round(self * fractions) / fractions
    }
    
    func truncateDefault() -> Self {
        return truncate(10000000)
    }
}
