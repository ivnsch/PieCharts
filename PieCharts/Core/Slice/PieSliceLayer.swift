//
//  PieSliceLayer.swift
//  PieChart
//
//  Created by ischuetz on 14/06/16.
//  Copyright © 2016 Ivan Schütz. All rights reserved.
//

import UIKit
import Darwin

open class PieSliceLayer: CALayer, CAAnimationDelegate {
    
    public var color = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    fileprivate(set) var startAngle: CGFloat = 0
    fileprivate(set) var endAngle: CGFloat = 0
    
    var angles: (CGFloat, CGFloat) = (0, 0) {
        didSet {
            startAngle = angles.0
            endAngle = angles.1
            present(animated: true)
        }
    }
    
    @NSManaged var startAngleManaged: CGFloat
    @NSManaged var endAngleManaged: CGFloat
    
    public var innerRadius: CGFloat = 50
    public var outerRadius: CGFloat = 100
    var referenceAngle: CGFloat = CGFloat.pi * 3 / 2 // Top center
    public var selectedOffset: CGFloat = 30
    var animDuration: Double = 0.5
    var strokeColor: UIColor = UIColor.black
    var strokeWidth: CGFloat = 0
    
    public weak var sliceDelegate: PieSliceDelegate?
 
    var sliceData: PieSliceData? // Easy identification in delegates
    
    fileprivate var animDelay: Double = 0
    
    fileprivate(set) var center: CGPoint = CGPoint.zero
    
    public fileprivate(set) var path: CGPath?
    
    public var midAngle: CGFloat {
        return internalMidAngle + referenceAngle
    }
    
    fileprivate var internalMidAngle: CGFloat {
        return (startAngle + endAngle) / 2
    }
    
    public var arcCenter: CGPoint {
        return calculatePosition(angle: midAngle, p: center, offset: (outerRadius - innerRadius) / 2 + innerRadius)
    }
    
    public var selected: Bool = false {
        didSet {
            animateSelected(selected: selected)
            if let sliceData = sliceData {
                sliceDelegate?.onSelected(slice: PieSlice(data: sliceData, view: self), selected: selected)
            } else {
                print("Invalid state: Selected slice but there's no model")
            }
        }
    }
    
    public init(color: UIColor, startAngle: CGFloat, endAngle: CGFloat, animDelay: Double, center: CGPoint) {
        
        self.color = color
        self.startAngle = startAngle
        self.endAngle = endAngle
        
        self.animDelay = animDelay
        
        self.center = center
        
        super.init()
        
        contentsScale = UIScreen.main.scale
    }
    
    
    var disableAnimation: Bool = false
    
    fileprivate func withDisabledAnimation(f: () -> Void) {
        disableAnimation = true
        f()
        disableAnimation = false
    }

    func presentStartAngle(angle: CGFloat, animated: Bool) {
        let f = {self.startAngleManaged = angle}
        if animated {
            f()
        } else {
            withDisabledAnimation {
                f()
            }
        }
    }
    
    func presentEndAngle(angle: CGFloat, animated: Bool) {
        let f = {self.endAngleManaged = angle}
        if animated {
            f()
        } else {
            withDisabledAnimation {
                f()
            }
        }
    }
    
    func present(animated: Bool) {
        presentStartAngle(angle: startAngle, animated: animated)
        presentEndAngle(angle: endAngle, animated: animated)
        
        if !animated {
            guard let data = sliceData else {return}
            sliceDelegate?.onStartAnimation(slice: PieSlice(data: data, view: self))
            sliceDelegate?.onEndAnimation(slice: PieSlice(data: data, view: self))
        }
    }
    
    func rotate(angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, center.x - position.x, center.y - position.y, 0)
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)
        transform = CATransform3DTranslate(transform, position.x - center.x, position.y - center.y, 0)
        self.transform = transform
    }
    
    override init(layer: Any) {
        if let pieSlice = layer as? PieSliceLayer {
            
            color = pieSlice.color
            innerRadius = pieSlice.innerRadius
            outerRadius = pieSlice.outerRadius
            
            animDelay = pieSlice.animDelay
            
            center = pieSlice.center
            
            startAngle = pieSlice.startAngle
            endAngle = pieSlice.endAngle
        }
        
        super.init(layer: layer)
        
        if let pieSlice = layer as? PieSliceLayer {
            startAngleManaged = pieSlice.startAngleManaged
            endAngleManaged = pieSlice.endAngleManaged
        }
    }
    
    func makeAnimationForKey(_ key: String) -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: key)
        
        let from = key == "startAngleManaged" ? startAngleManaged : endAngleManaged
        
        anim.fromValue = from
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        anim.duration = animDuration
        
        anim.delegate = self
        return anim
    }
    
    public func animationDidStart(_ anim: CAAnimation) {
        guard let data = sliceData else {return}
        sliceDelegate?.onStartAnimation(slice: PieSlice(data: data, view: self))
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let data = sliceData else {return}
        sliceDelegate?.onEndAnimation(slice: PieSlice(data: data, view: self))
    }
    
    open override func action(forKey event: String) -> CAAction? {
        if disableAnimation {
            return NSNull()
        }
        
        if event == "startAngleManaged" || event == "endAngleManaged" {
            return makeAnimationForKey(event)
        }
        return super.action(forKey: event)
    }
    
    open override class func needsDisplay(forKey key: String) -> Bool {
        if key == "startAngleManaged" || key == "endAngleManaged" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    open override func draw(in ctx: CGContext) {
        ctx.beginPath()
        ctx.move(to: CGPoint(x: center.x, y: center.y))

        let path = createArcPath(center: center)
        ctx.addPath(path)
        self.path = path
        
        ctx.setFillColor(color.cgColor)
        ctx.setStrokeColor(strokeColor.cgColor)
        ctx.setLineWidth(strokeWidth)
        
        ctx.drawPath(using: CGPathDrawingMode.fillStroke)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createArcPath(center: CGPoint, offsetAngle: CGFloat = 0) -> CGPath {
        let path = CGMutablePath()
        path.addRelativeArc(center: center, radius: innerRadius, startAngle: startAngleManaged + offsetAngle, delta: endAngleManaged - startAngleManaged)
        path.addRelativeArc(center: center, radius: outerRadius, startAngle: endAngleManaged + offsetAngle, delta: -(endAngleManaged - startAngleManaged))
        path.closeSubpath()
        return path
    }
    
    open override func contains(_ p: CGPoint) -> Bool {
        let delta = selected ? {
            let pos = calculatePosition(angle: midAngle, p: position, offset: -selectedOffset)
            return CGPoint(x: position.x - pos.x, y: position.y - pos.y)
            }() : CGPoint.zero
        let center = CGPoint(x: self.center.x + delta.x, y: self.center.y + delta.y)
        return createArcPath(center: center, offsetAngle: referenceAngle).contains(p)
    }
    
    public func calculatePosition(angle: CGFloat, p: CGPoint, offset: CGFloat) -> CGPoint {
        return CGPoint(x: p.x + offset * cos(angle), y: p.y + offset * sin(angle))
    }
    
    fileprivate func animateSelected(selected: Bool) {
        position = calculatePosition(angle: midAngle, p: position, offset: selected ? selectedOffset : -selectedOffset)
    }
    
    public func midPoint(radius: CGFloat) -> CGPoint {
        let x = cos(midAngle) * radius
        let y = sin(midAngle) * radius
        return CGPoint(x: x + center.x, y: y + center.y)
    }
    
    public func maxRectWidth(center: CGPoint, height: CGFloat) -> CGFloat {
        
        let startAngleCC = CGFloat.pi * 2 - startAngle + referenceAngle
        let endAngleCC = CGFloat.pi * 2 - endAngle + referenceAngle
        
        let a = (center.x - self.center.x) * tan(startAngleCC)
        let b = (center.x - self.center.x) * tan(endAngleCC)
        let c = abs(abs(center.y - self.center.y) - a)
        let d = abs(abs(center.y - self.center.y) - b)
        let height = min(height, min(c, d) * 2)
        
        let h1 = self.center.y - ((center.y - (height / 2)))
        let h2 = self.center.y - ((center.y + (height / 2)))
        
        let startAngleIntersection1 = h1 / tan(startAngleCC)
        let startAngleIntersection2 = h2 / tan(startAngleCC)
        let endAngleIntersection1 = h1 / tan(endAngleCC)
        let endAngleIntersection2 = h2 / tan(endAngleCC)
        
        let smallestStartAngleDistance = min(abs(center.x - self.center.x - startAngleIntersection1), abs(center.x - self.center.x - startAngleIntersection2))
        let smallestEndAngleDistance = min(abs(center.x - self.center.x - endAngleIntersection1), abs(center.x - self.center.x - endAngleIntersection2))
        
        return min(smallestStartAngleDistance, smallestEndAngleDistance) * 2
    }
    
    
    open override var debugDescription: String {
        return "{data: \(String(describing: sliceData)), start: \(startAngle.radiansToDegrees), end: \(endAngle.radiansToDegrees)}"
    }
  
}
