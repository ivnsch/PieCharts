//
//  PieChart.swift
//  PieChart2
//
//  Created by ischuetz on 06/06/16.
//  Copyright © 2016 Ivan Schütz. All rights reserved.
//

import UIKit

open class PieChart: UIView {
    
    public fileprivate(set) var container: CALayer = CALayer()
    
    fileprivate var slices: [PieSlice] = []
    
    public var models: [PieSliceModel] = [] {
        didSet {
            slices = generateSlices(models)
            showSlices()
        }
    }
    
    public var settings = PieChartSettings()
    
    public weak var delegate: PieChartDelegate?
    
    public var layers: [PieChartLayer] = [] {
        didSet {
            for layer in layers {
                layer.chart = self
            }
        }
    }
    
    public var totalValue: Double {
        return models.reduce(0){$0 + $1.value}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        layer.addSublayer(container)
        container.frame = bounds
    }
    
    fileprivate func generateSlices(_ models: [PieSliceModel]) -> [PieSlice] {
        var slices: [PieSlice] = []
        var lastEndAngle: CGFloat = 0
        
        for (index, model) in models.enumerated() {
            let percentage = 1 / (totalValue / model.value)
            let angle = (Double.pi * 2) * percentage
            let newEndAngle = lastEndAngle + CGFloat(angle)
            
            let data = PieSliceData(model: model, id: index, percentage: percentage)
            let slice = PieSlice(data: data, view: PieSliceLayer(color: model.color, startAngle: lastEndAngle, endAngle: newEndAngle, animDelay: 0, center: bounds.center))
            
            slice.view.frame = bounds
            
            slice.view.sliceData = data
            
            slice.view.innerRadius = settings.innerRadius
            slice.view.outerRadius = settings.outerRadius
            slice.view.referenceAngle = settings.referenceAngle
            slice.view.selectedOffset = settings.selectedOffset
            
            slice.view.sliceDelegate = self
            
            slices.append(slice)
            
            lastEndAngle = newEndAngle
        }
        
        return slices
    }
    
    fileprivate func showSlices() {
        for slice in slices {
            container.addSublayer(slice.view)
            slice.view.startAnim()
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            
            if let slice = (slices.filter{$0.view.contains(point)}).first {
                slice.view.selected = !slice.view.selected
            }
        }
    }
    
    public func removeSlices() {
        for slice in slices {
            slice.view.removeFromSuperlayer()
        }
        slices = []
    }
}

extension PieChart: PieSliceDelegate {
    
    public func onStartAnimation(slice: PieSlice) {
        for layer in layers {
            layer.onStartAnimation(slice: slice)
        }
        delegate?.onStartAnimation(slice: slice)
    }
    
    public func onEndAnimation(slice: PieSlice) {
        for layer in layers {
            layer.onEndAnimation(slice: slice)
        }
        delegate?.onEndAnimation(slice: slice)
    }
    
    public func onSelected(slice: PieSlice, selected: Bool) {
        for layer in layers {
            layer.onSelected(slice: slice, selected: selected)
        }
        delegate?.onSelected(slice: slice, selected: selected)
    }
}
