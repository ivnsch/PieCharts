//
//  PieSliceData.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public class PieSliceData: CustomDebugStringConvertible {
    
    public let model: PieSliceModel
    public internal(set) var id: Int
    public internal(set) var percentage: Double
    
    public init(model: PieSliceModel, id: Int, percentage: Double) {
        self.model = model
        self.id = id
        self.percentage = percentage
    }
    
    public var debugDescription: String {
        return "{model: \(model.debugDescription), id: \(id), percentage: \(percentage)}"
    }
}

