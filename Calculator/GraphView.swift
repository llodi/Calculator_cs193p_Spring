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
                orign?.x += transition.x
                orign?.y += transition.y
                recognizer.setTranslation(CGPointZero, inView: self)
            }
        default: break
        }
    }
    
    func moveOrignTo(recognizer: UITapGestureRecognizer){
        recognizer.numberOfTapsRequired = 2
        if recognizer.state == .Ended {
            orign = recognizer.locationInView(self)
        }
    }
    
    override func drawRect(rect: CGRect) {
        //orign = graphCenter
        orign = orign ?? graphCenter
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(bounds, origin: orign!, pointsPerUnit: scale)
    }
}
