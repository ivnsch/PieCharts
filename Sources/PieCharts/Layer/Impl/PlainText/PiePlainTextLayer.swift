//
//  PiePlainTextLayer.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

open class PiePlainTextLayerSettings: PieCustomViewsLayerSettings {
    
    public var label: PieChartLabelSettings = PieChartLabelSettings()
}

open class PiePlainTextLayer: PieChartLayer {
    
    public weak var chart: PieChart?
    
    public var settings: PiePlainTextLayerSettings = PiePlainTextLayerSettings()
    
    public var onNotEnoughSpace: ((UILabel, CGSize) -> Void)?
    
    fileprivate var sliceViews = [PieSlice: UILabel]()
    
    public var animator: PieViewLayerAnimator = AlphaPieViewLayerAnimator()
    
    public init() {}
    
    public func onEndAnimation(slice: PieSlice) {
        addItems(slice: slice)
    }
    
    public func addItems(slice: PieSlice) {
        guard sliceViews[slice] == nil else {return}
        
        let label: UILabel = settings.label.labelGenerator?(slice) ?? {
            let label = UILabel()
            label.backgroundColor = settings.label.bgColor
            label.textColor = settings.label.textColor
            label.font = settings.label.font
            return label
            }()
        
        let text = settings.label.textGenerator(slice)
        let size = (text as NSString).size(withAttributes: [ .font: settings.label.font])
        
        let center = settings.viewRadius.map{slice.view.midPoint(radius: $0)} ?? slice.view.arcCenter
        let availableSize = CGSize(width: slice.view.maxRectWidth(center: center, height: size.height), height: size.height)
        
        if !settings.hideOnOverflow || availableSize.contains(size) {
            label.text = text
            label.sizeToFit()
        } else {
            onNotEnoughSpace?(label, availableSize)
        }
        
        label.center = center
        
        chart?.addSubview(label)
        
        animator.animate(label)
        
        sliceViews[slice] = label
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
