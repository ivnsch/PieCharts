//
//  CGSize.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

extension CGSize {
    
    func contains(_ size: CGSize) -> Bool {
        return width >= size.width && height >= size.height
    }
}
