//
//  DoughnutDemo.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit
import PieCharts

class DoughnutDemo: UIViewController, PieChartDelegate {
    
    @IBOutlet weak var chartView: PieChart!
    
    override func viewDidAppear(_ animated: Bool) {
        
        var settings = PieChartSettings()
        settings.innerRadius = 70
        settings.outerRadius = 100
        settings.referenceAngle = 0
        settings.selectedOffset = 30
        
        chartView.settings = settings
        chartView.models = createModels()
        chartView.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
        chartView.delegate = self
    }
    
    // MARK: - PieChartDelegate
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }
    
    // MARK: - Models
    
    fileprivate func createModels() -> [PieSliceModel] {
        let alpha: CGFloat = 0.5
        
        return [
            PieSliceModel(value: 2.1, color: UIColor.yellow.withAlphaComponent(alpha)),
            PieSliceModel(value: 3, color: UIColor.blue.withAlphaComponent(alpha)),
            PieSliceModel(value: 1, color: UIColor.green.withAlphaComponent(alpha)),
            PieSliceModel(value: 4, color: UIColor.cyan.withAlphaComponent(alpha)),
            PieSliceModel(value: 2, color: UIColor.red.withAlphaComponent(alpha)),
            PieSliceModel(value: 1.5, color: UIColor.magenta.withAlphaComponent(alpha)),
            PieSliceModel(value: 0.5, color: UIColor.orange.withAlphaComponent(alpha)),
            PieSliceModel(value: 2.1, color: UIColor.black.withAlphaComponent(alpha)),
            PieSliceModel(value: 3, color: UIColor.brown.withAlphaComponent(alpha)),
            PieSliceModel(value: 1, color: UIColor.lightGray.withAlphaComponent(alpha)),
            PieSliceModel(value: 4, color: UIColor.darkGray.withAlphaComponent(alpha)),
            PieSliceModel(value: 2, color: UIColor.gray.withAlphaComponent(alpha)),
            PieSliceModel(value: 1.5, color: UIColor.purple.withAlphaComponent(alpha))
        ]
    }
    
    // MARK: - Layers
    
    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {
        
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 55
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
}
