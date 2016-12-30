//
//  PieSliceData.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public struct PieSliceData: CustomDebugStringConvertible {
    
    public let model: PieSliceModel
    public let id: Int
    public let percentage: Double
    
    public init(model: PieSliceModel, id: Int, percentage: Double) {
        self.model = model
        self.id = id
        self.percentage = percentage
    }
    
    public var debugDescription: String {
        return "{model: \(model.debugDescription), id: \(id), percentage: \(percentage)}"
    }
}

