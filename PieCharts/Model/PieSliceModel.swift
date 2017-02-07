//
//  PieSliceModel.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public class PieSliceModel: CustomDebugStringConvertible {
    
    public let name: String?
    public let value: Double
    public let color: UIColor
    
    public init(name: String? = nil, value: Double, color: UIColor) {
        self.name = name
        self.value = value
        self.color = color
    }
    
    public var debugDescription: String {
        return "{value: \(value)}"
    }
}
