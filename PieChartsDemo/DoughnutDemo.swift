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
    
    fileprivate static let alpha: CGFloat = 0.5
    let colors = [
        UIColor.yellow.withAlphaComponent(alpha),
        UIColor.green.withAlphaComponent(alpha),
        UIColor.purple.withAlphaComponent(alpha),
        UIColor.cyan.withAlphaComponent(alpha),
        UIColor.darkGray.withAlphaComponent(alpha),
        UIColor.red.withAlphaComponent(alpha),
        UIColor.magenta.withAlphaComponent(alpha),
        UIColor.orange.withAlphaComponent(alpha),
        UIColor.brown.withAlphaComponent(alpha),
        UIColor.lightGray.withAlphaComponent(alpha),
        UIColor.gray.withAlphaComponent(alpha),
    ]
    fileprivate var currentColorIndex = 0

    
    override func viewDidAppear(_ animated: Bool) {
        
        var settings = PieChartSettings()
        settings.innerRadius = 70
        settings.outerRadius = 100
        settings.selectedOffset = 30
        settings.animDuration = 0.5
        
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

        let models = [
            PieSliceModel(value: 2, color: colors[0]),
            PieSliceModel(value: 2, color: colors[1]),
            PieSliceModel(value: 2, color: colors[2])
        ]
        
        currentColorIndex = models.count
        return models
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
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? ""
        }
        
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
    
    @IBAction func onPlusTap(sender: UIButton) {
        let newModel = PieSliceModel(value: 4 * Double(CGFloat.random()), color: colors[currentColorIndex])
        chartView.insertSlice(index: 0, model: newModel)
        currentColorIndex = (currentColorIndex + 1) % colors.count
        if currentColorIndex == 2 {currentColorIndex += 1} // avoid same contiguous color
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}
