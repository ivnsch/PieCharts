//
//  PieChartLabelSettings.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

public class PieChartLabelSettings {
    // String type checker - check type to use attributed string
    public enum `Type` {
        case plain
        case attributed
    }
    
    public var type: Type = .plain
    public var textColor: UIColor = UIColor.black
    public var bgColor: UIColor = UIColor.clear
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 20)
    
    public var textGenerator: (PieSlice) -> String = { "\($0.data.model.value)" }
    public var attributedTextGenerator: (PieSlice) -> NSAttributedString = { NSAttributedString(string: "\($0.data.model.value)") }
    
    // Optional custom label - when this is set presentations settings (textColor, etc.) are ignored
    public var labelGenerator: ((PieSlice) -> UILabel)?
}
