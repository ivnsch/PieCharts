//
//  PieChartLayer.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public protocol PieChartLayer: PieChartDelegate {
    
    var chart: PieChart? {get set}
    
    func onEndAnimation(slice: PieSlice)

    func addItems(slice: PieSlice)

    func clear()
}
