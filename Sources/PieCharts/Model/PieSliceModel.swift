//
//  PieSliceModel.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public class PieSliceModel: CustomDebugStringConvertible {
    
    public let value: Double
    public let color: UIColor
    public let obj: Any? /// optional object to pass around e.g. to the layer's text generators

    public init(value: Double, color: UIColor, obj: Any? = nil) {
        self.value = value
        self.color = color
        self.obj = obj
    }
    
    public var debugDescription: String {
        return "{value: \(value), obj: \(String(describing: obj))}"
    }
}
