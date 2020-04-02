//
//  PieViewLayer.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

open class PieCustomViewsLayerSettings {
    
    public var viewRadius: CGFloat?
    
    public var hideOnOverflow = true // NOTE: Considers only space defined by angle with origin at the center of the pie chart. Arcs (inner/outer radius) are ignored.
    
    public init() {}
}

open class PieCustomViewsLayer: PieChartLayer {
    
    public weak var chart: PieChart?
    
    public var settings: PieCustomViewsLayerSettings = PieCustomViewsLayerSettings()
    
    public var onNotEnoughSpace: ((UIView, CGSize) -> Void)?
    
    fileprivate var sliceViews = [PieSlice: UIView]()
    
    public var animator: PieViewLayerAnimator = AlphaPieViewLayerAnimator()
    
    public var viewGenerator: ((PieSlice, CGPoint) -> UIView)?
    
    public init() {}
    
    public func onEndAnimation(slice: PieSlice) {
        addItems(slice: slice)
    }
    
    public func addItems(slice: PieSlice) {
        guard sliceViews[slice] == nil else {return}
        
        calculateLabelExtraAngles()
        
        let center: CGPoint
        if let viewRadius = settings.viewRadius {
            center = slice.view.midPointForLabel(radius: viewRadius)
        } else {
            center = slice.view.arcCenter
        }

        guard let view = viewGenerator?(slice, center) else {print("Need a view generator to create views!"); return}
        
        let size = view.frame.size
        
        let availableSize = CGSize(width: slice.view.maxRectWidth(center: center, height: size.height), height: size.height)
        
        if !settings.hideOnOverflow || availableSize.contains(size) {
            
            view.center = center
            
            chart?.addSubview(view)
            
        } else {
            onNotEnoughSpace?(view, availableSize)
        }
        
        animator.animate(view)
        
        sliceViews[slice] = view
    }
    
    public func calculateLabelExtraAngles() {
        chart?.slices.forEach { calculateLabelExtraAngle(for: $0) }
    }
    
    public func calculateLabelExtraAngle(for slice: PieSlice) {
        guard let chart = chart else { return }
        guard let labelOverlapAngleConst = chart.labelOverlapAngleConst else { return }
        let sliceIndex = slice.data.id
        guard sliceIndex > 0 else { return }
        guard let previousSlice = chart.slices.filter({ $0.data.id == (sliceIndex - 1) }).first else { return }

        let diffBetweenSlices = slice.view.midAngleForLabel() - previousSlice.view.midAngleForLabel()
        if diffBetweenSlices > labelOverlapAngleConst {
            // np wont intersect
            return
        }
        
        let newExtraAngleForSlice = previousSlice.view.midAngleForLabel() + labelOverlapAngleConst - slice.view.midAngle
        slice.view.setExtraAngleForLabel( newExtraAngleForSlice )
    }
    
    public func onSelected(slice: PieSlice, selected: Bool) {
        guard let label = sliceViews[slice] else {print("Invalid state: slice not in dictionary"); return}
        
        let p = slice.view.calculatePosition(angle: slice.view.midAngle, p: label.center, offset: selected ? slice.view.selectedOffset : -slice.view.selectedOffset)
        UIView.animate(withDuration: 0.15) {
            label.center = p
        }
    }
    
    public func clear() {
        for (_, view) in sliceViews {
            view.removeFromSuperview()
        }
        sliceViews.removeAll()
    }
}
