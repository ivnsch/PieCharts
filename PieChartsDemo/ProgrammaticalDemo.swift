//
//  ProgrammaticalDemo.swift
//  PieCharts
//
//  Created by Hyun Min Choi on 2017. 1. 23..
//  Copyright © 2017년 Ivan Schuetz. All rights reserved.
//

import UIKit
import PieCharts

class ProgrammaticalDemo: UIViewController, PieChartDelegate {
    let chartView: PieChart = PieChart(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
//    convenience init() {
//        self.init(nibName: nil, bundle: nil)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(chartView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        chartView.layers = [createCustomViewsLayer(), createTextLayer()]
        chartView.delegate = self
        chartView.models = createModels() // order is important - models have to be set at the end
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
            PieSliceModel(value: 0.5, color: UIColor.orange.withAlphaComponent(alpha))
        ]
    }
    
    // MARK: - Layers
    
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 135
        settings.hideOnOverflow = false
        viewLayer.settings = settings
        
        viewLayer.viewGenerator = createViewGenerator()
        
        return viewLayer
    }
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 75
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        return {slice, center in
            
            let container = UIView()
            container.frame.size = CGSize(width: 100, height: 40)
            container.center = center
            let view = UIImageView()
            view.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
            container.addSubview(view)
            
            if slice.data.id == 3 || slice.data.id == 0 {
                let specialTextLabel = UILabel()
                specialTextLabel.textAlignment = .center
                if slice.data.id == 0 {
                    specialTextLabel.text = "views"
                    specialTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
                } else if slice.data.id == 3 {
                    specialTextLabel.textColor = UIColor.blue
                    specialTextLabel.text = "Custom"
                }
                specialTextLabel.sizeToFit()
                specialTextLabel.frame = CGRect(x: 0, y: 40, width: 100, height: 20)
                container.addSubview(specialTextLabel)
                container.frame.size = CGSize(width: 100, height: 60)
            }
            
            
            // src of images: www.freepik.com, http://www.flaticon.com/authors/madebyoliver
            let imageName: String? = {
                switch slice.data.id {
                case 0: return "fish"
                case 1: return "grapes"
                case 2: return "doughnut"
                case 3: return "water"
                case 4: return "chicken"
                case 5: return "beet"
                case 6: return "cheese"
                default: return nil
                }
            }()
            
            view.image = imageName.flatMap{UIImage(named: $0)}
            
            return container
        }
    }
}
