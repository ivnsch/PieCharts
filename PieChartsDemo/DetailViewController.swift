//
//  DetailViewController.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailItem: Demo? {
        didSet {
            self.configureView()
        }
    }
    var currentDemoController: UIViewController?
    
    func configureView() {
        if let example: Demo = detailItem  {
            switch example {
            case .doughnut:
                showExampleController(DoughnutDemo())
            case .customViews:
                showExampleController(CustomViewsDemo())
            }
        }
    }
    
    fileprivate func showExampleController(_ controller: UIViewController) {
        if let currentDemoController = currentDemoController {
            currentDemoController.removeFromParentViewController()
            currentDemoController.view.removeFromSuperview()
        }
        addChildViewController(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        currentDemoController = controller
    }
}
