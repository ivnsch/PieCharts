//
//  PieSliceDelegate.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public protocol PieSliceDelegate: class {
    
    func onStartAnimation(slice: PieSlice)
    
    func onEndAnimation(slice: PieSlice)
    
    func onSelected(slice: PieSlice, selected: Bool)
}
