//
//  Int.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 05/01/2017.
//  Copyright © 2017 Ivan Schuetz. All rights reserved.
//

import Foundation

extension Int {
    
    var degreesToRadians: Double {
        return Double(self) * .pi / 180
    }
    
    var radiansToDegrees: Double {
        return Double(self) * 180 / .pi
    }
}
