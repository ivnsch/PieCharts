//
//  PieLineTextLayer.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public struct PieLineTextLayerSettings {
    
    public var segment1Length: CGFloat = 15
    public var segment2Length: CGFloat = 15
    public var lineColor: UIColor = UIColor.black
    public var lineWidth: CGFloat = 1
    public var chartOffset: CGFloat = 5
    public var labelOffset: CGFloat = 5
    public var label: PieChartLabelSettings = PieChartLabelSettings()
    
    public init() {}
}

open class PieLineTextLayer: PieChartLayer {
    
    public weak var chart: PieChart?
    
    public var settings: PieLineTextLayerSettings = PieLineTextLayerSettings()
    
    fileprivate var sliceViews = [PieSlice: (CALayer, UILabel)]()
    
    public var animator: PieLineTextLayerAnimator = AlphaPieLineTextLayerAnimator()
    
    public init() {}
    
    public func onEndAnimation(slice: PieSlice) {
        addItems(slice: slice)
    }
    
    public func addItems(slice: PieSlice) {
        guard sliceViews[slice] == nil else {return}
        
        let p1 = slice.view.calculatePosition(angle: slice.view.midAngle, p: slice.view.center, offset: slice.view.outerRadius + settings.chartOffset)
        let p2 = slice.view.calculatePosition(angle: slice.view.midAngle, p: slice.view.center, offset: slice.view.outerRadius + settings.segment1Length)
        
        let angle = slice.view.midAngle.truncatingRemainder(dividingBy: (CGFloat.pi * 2))
        let isRightSide = angle >= 0 && angle <= (CGFloat.pi / 2) || (angle > (CGFloat.pi * 3 / 2) && angle <= CGFloat.pi * 2)
        
        let p3 = CGPoint(x: p2.x + (isRightSide ? settings.segment2Length : -settings.segment2Length), y: p2.y)
        
        let lineLayer = createLine(p1: p1, p2: p2, p3: p3)
        let label = createLabel(slice: slice, isRightSide: isRightSide, referencePoint: p3)
        
        chart?.container.addSublayer(lineLayer)
        animator.animate(lineLayer)
        
        chart?.addSubview(label)
        animator.animate(label)
        
        sliceViews[slice] = (lineLayer, label)
    }
    
    public func createLine(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CALayer {
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = settings.lineColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.borderWidth = settings.lineWidth
        
        return layer
    }
    
    public func createLabel(slice: PieSlice, isRightSide: Bool, referencePoint: CGPoint) -> UILabel {
        
        let label: UILabel = settings.label.labelGenerator?(slice) ?? {
            let label = UILabel()
            label.backgroundColor = settings.label.bgColor
            label.textColor = settings.label.textColor
            label.font = settings.label.font
            return label
            }()
        
        label.text = settings.label.textGenerator(slice)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: referencePoint.x - (isRightSide ? 0 : label.frame.width) + ((isRightSide ? 1 : -1) * settings.labelOffset), y: referencePoint.y - label.frame.height / 2)
        
        return label
    }
    
    public func onSelected(slice: PieSlice, selected: Bool) {
        guard let (layer, label) = sliceViews[slice] else {print("Invalid state: slice not in dictionary"); return}
        
        let offset = selected ? slice.view.selectedOffset : -slice.view.selectedOffset
        UIView.animate(withDuration: 0.15) {
            label.center = slice.view.calculatePosition(angle: slice.view.midAngle, p: label.center, offset: offset)
        }
        
        layer.position = slice.view.calculatePosition(angle: slice.view.midAngle, p: layer.position, offset: offset)
    }
    
    public func clear() {
        for (_, layerView) in sliceViews {
            layerView.0.removeFromSuperlayer()
            layerView.1.removeFromSuperview()
        }
        sliceViews.removeAll()
    }
}
