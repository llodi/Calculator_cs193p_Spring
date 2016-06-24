//
//  GraphViewController.swift
//  Calculator
//
//  Created by Ilya Dolgopolov on 17/06/16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: graphView, action: #selector(GraphView.scale(_:))
            ))
            
            graphView.addGestureRecognizer(UIPanGestureRecognizer(
                target: graphView, action: #selector(GraphView.moveTo(_:))
            ))
            
            graphView.addGestureRecognizer(UITapGestureRecognizer(
                target: graphView, action: #selector(GraphView.moveOriginTo)
            ))
            graphView.yForX = { [weak self] (x: Double) in
                self?.brain.variableValues["M"] = x
                return self?.brain.result
            }
            updateUI()
        }
    }
    
    private func updateUI() {
        graphView?.setNeedsDisplay()
    }
    
    private var brain = CalculatorBrain()
    
    typealias PropertyList = AnyObject
    var program: PropertyList? {
        didSet {
            brain.variableValues["M"] = 0
            brain.program = program!
            let descript = brain.description.componentsSeparatedByString(",").last ?? " "
            title = "y = " + descript ?? " "
            updateUI()
        }
    }
    
}
