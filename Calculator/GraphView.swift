//
//  GraphView.swift
//  Calculator
//
//  Created by Ilya Dolgopolov on 17/06/16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    var yForX: ((x: Double) -> Double?)? { didSet { setNeedsDisplay() } }
    
    let axesDrawer = AxesDrawer(color: UIColor.blueColor())
    
    private var graphCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet {setNeedsDisplay() } }
    @IBInspectable
    var origin: CGPoint? { didSet {setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet {setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet {setNeedsDisplay() } }
    
    func scale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    func moveTo(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Changed,.Ended:
            let transition = recognizer.translationInView(self)
            if transition != CGPointZero {
                origin?.x += transition.x
                origin?.y += transition.y
                recognizer.setTranslation(CGPointZero, inView: self)
            }
        default: break
        }
    }
    
    func moveOriginTo(recognizer: UITapGestureRecognizer){
        recognizer.numberOfTapsRequired = 2
        if recognizer.state == .Ended {
            origin = recognizer.locationInView(self)
        }
    }
    
    func drawCurveInRect(bounds: CGRect, origin: CGPoint, pointsPerUnit: CGFloat){
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var point = CGPoint()
        
        var firstValue = true
        for i in 0...Int(bounds.size.width * contentScaleFactor) {
            point.x = CGFloat(i) / contentScaleFactor
            if let y = self.yForX?(x: Double((point.x - origin.x) / scale)){
                if !y.isNormal && !y.isZero {
                    firstValue = true
                    continue
                }
                point.y = origin.y - CGFloat(y) * scale
                if firstValue {
                    path.moveToPoint(point)
                    firstValue = false
                } else {
                    path.addLineToPoint(point)
                }
            } else {
                firstValue = true
            }
        }
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        origin = graphCenter
        //origin = origin ?? graphCenter
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(bounds, origin: origin!, pointsPerUnit: scale)
        drawCurveInRect(bounds, origin: origin!, pointsPerUnit: scale)
    }
}
