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
                target: graphView, action: #selector(GraphView.moveOrignTo)
                ))
            
            
        }
    }
}
