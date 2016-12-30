//
//  PieChartDelegate.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public protocol PieChartDelegate: class {
    
    func onGenerateSlice(slice: PieSlice)
    
    func onStartAnimation(slice: PieSlice)
    
    func onEndAnimation(slice: PieSlice)
    
    func onSelected(slice: PieSlice, selected: Bool)
}

extension PieChartDelegate {
    
    public func onGenerateSlice(slice: PieSlice) {}
    
    public func onStartAnimation(slice: PieSlice) {}
    
    public func onEndAnimation(slice: PieSlice) {}
}
