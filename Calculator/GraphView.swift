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
    
    let axesDrawer = AxesDrawer(color: UIColor.blueColor())
    
    private var graphCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet {setNeedsDisplay() } }
    @IBInspectable
    var orign: CGPoint? { didSet {setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet {setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet {setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        orign = graphCenter
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(bounds, origin: orign!, pointsPerUnit: scale)
    }
}
