//
//  PieChart.swift
//  PieChart2
//
//  Created by ischuetz on 06/06/16.
//  Copyright © 2016 Ivan Schütz. All rights reserved.
//

import UIKit

@IBDesignable open class PieChart: UIView {
    
    // MARK: - Settings
    
    /// Inner radius of slices - set this to 0 for "no gap".
    @IBInspectable public var innerRadius: CGFloat = 50
    
    /// Outer radius of slices.
    @IBInspectable public var outerRadius: CGFloat = 100
    
    /// Stroke (border) color of slices.
    @IBInspectable public var strokeColor: UIColor = UIColor.black
    
    /// Stroke (border) width of slices.
    @IBInspectable public var strokeWidth: CGFloat = 0
    
    /// Pt that will be added to (inner/outer)radius of slice when selecting it.
    @IBInspectable public var selectedOffset: CGFloat = 30
    
    /// Duration it takes to slices to expand.
    @IBInspectable public var animDuration: Double = 0.5
    
    /// Start angle of chart, in degrees, clockwise. 0 is 3 o'clock, 90 is 6 o'clock, etc.
    @IBInspectable public var referenceAngle: CGFloat = 0 {
        didSet {
            for layer in layers {
                layer.clear()
            }
            
            let delta = (referenceAngle - oldValue).degreesToRadians
            for slice in slices {
                slice.view.angles = (slice.view.startAngle + delta, slice.view.endAngle + delta)
            }
            
            for slice in slices {
                slice.view.present(animated: false)
            }
        }
    }
    
    var animated: Bool {
        return animDuration > 0
    }

    // MARK: -
    
    public fileprivate(set) var container: CALayer = CALayer()
    
    public fileprivate(set) var slices: [PieSlice] = []
    
    public var models: [PieSliceModel] = [] {
        didSet {
            if oldValue.isEmpty {
                slices = generateSlices(models)
                showSlices()
            }
        }
    }
    
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
    
    public override init(frame: CGRect) {
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
            let (newEndAngle, slice) = generateSlice(model: model, index: index, lastEndAngle: lastEndAngle, totalValue: totalValue)
            slices.append(slice)
            
            lastEndAngle = newEndAngle
        }
        
        return slices
    }
    
    fileprivate func generateSlice(model: PieSliceModel, index: Int, lastEndAngle: CGFloat, totalValue: Double) -> (CGFloat, PieSlice) {
        let percentage = 1 / (totalValue / model.value)
        let angle = (Double.pi * 2) * percentage
        let newEndAngle = lastEndAngle + CGFloat(angle)
        
        let data = PieSliceData(model: model, id: index, percentage: percentage)
        let slice = PieSlice(data: data, view: PieSliceLayer(color: model.color, startAngle: lastEndAngle, endAngle: newEndAngle, animDelay: 0, center: bounds.center))
        
        slice.view.frame = bounds
        
        slice.view.sliceData = data
        
        slice.view.innerRadius = innerRadius
        slice.view.outerRadius = outerRadius
        slice.view.selectedOffset = selectedOffset
        slice.view.animDuration = animDuration
        slice.view.strokeColor = strokeColor
        slice.view.strokeWidth = strokeWidth
        slice.view.referenceAngle = referenceAngle.degreesToRadians
        
        slice.view.sliceDelegate = self

        self.delegate?.onGenerateSlice(slice: slice)

        return (newEndAngle, slice)
    }
    
    
    fileprivate func showSlices() {
        for slice in slices {
            container.addSublayer(slice.view)
            
            slice.view.rotate(angle: slice.view.referenceAngle)
            
            slice.view.present(animated: animated)
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
    
    public func insertSlice(index: Int, model: PieSliceModel) {
        
        guard index < slices.count else {print("Out of bounds index: \(index), slices count: \(slices.count), exit"); return}
        
        for layer in layers {
            layer.clear()
        }
        
        func wrap(angle: CGFloat) -> CGFloat {
            return angle.truncatingRemainder(dividingBy: CGFloat.pi * 2)
        }
        
        let newSlicePercentage = 1 / ((totalValue + model.value) / model.value)
        let remainingPercentage = 1 - newSlicePercentage
        
        let currentSliceAtIndexEndAngle = index == 0 ? 0 : wrap(angle: slices[index - 1].view.endAngle)
        let currentSliceAfterIndeStartAngle = index == 0 ? 0 : wrap(angle: slices[index].view.startAngle)
        
        var offset = CGFloat.pi * 2 * CGFloat(newSlicePercentage)
        var lastEndAngle = currentSliceAfterIndeStartAngle + offset
        
        let (_, slice) = generateSlice(model: model, index: index, lastEndAngle: currentSliceAtIndexEndAngle, totalValue: model.value + totalValue)
        
        container.addSublayer(slice.view)
        slice.view.rotate(angle: slice.view.referenceAngle)
        
        slice.view.presentEndAngle(angle: slice.view.startAngle, animated: false)
        slice.view.present(animated: animated)
        
        let slicesToAdjust = Array(slices[index..<slices.count]) + Array(slices[0..<index])
        
        models.insert(model, at: index)
        slices.insert(slice, at: index)

        for (index, slice) in slices.enumerated() {
            slice.data.id = index
        }
        
        for slice in slicesToAdjust {
            let currentAngle = slice.view.endAngle - slice.view.startAngle
            let newAngle = currentAngle * CGFloat(remainingPercentage)
            let angleDelta = newAngle - currentAngle
            
            let start = lastEndAngle < slice.view.startAngle ? CGFloat.pi * 2 + lastEndAngle : lastEndAngle
            offset = offset + angleDelta
            
            var end = slice.view.endAngle + offset
            end = end.truncateDefault() < slice.view.endAngle.truncateDefault() ? CGFloat.pi * 2 + end : end
            
            slice.view.angles = (start, end)
            
            lastEndAngle = wrap(angle: end)
            
            slice.data.percentage = 1 / (totalValue / slice.data.model.value)
        }
    }
    
    public func removeSlices() {
        for slice in slices {
            slice.view.removeFromSuperlayer()
        }
        slices = []
    }
    
    public func clear() {
        for layer in layers {
            layer.clear()
        }
        layers = []
        models = []
        removeSlices()
    }
    
    open override func prepareForInterfaceBuilder() {
        animDuration = 0
        strokeWidth = 1
        strokeColor = UIColor.lightGray
        
        let models = (0..<6).map {_ in
            PieSliceModel(value: 2, color: UIColor.clear)
        }
        
        self.models = models
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
