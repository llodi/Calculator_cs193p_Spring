//
//  ViewController.swift
//  Calculator
//
//  Created by Ilya Dolgopolov on 21.05.16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet weak var sequenceОfОperandsОndОperations: UILabel!
    
    private var userIsInTheMiddleOfTyping = false

    @IBOutlet weak var pi: UIButton!
    @IBOutlet weak var e: UIButton!
    @IBOutlet weak var sqrt: UIButton!
    @IBOutlet weak var devide: UIButton!
    @IBOutlet weak var tan: UIButton!
    
    @IBOutlet weak var stackView0: UIStackView!
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var stackView5: UIStackView!
    
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        reArrangedViewStacks(newCollection.verticalSizeClass)
    }
    
    private func reArrangedViewStacks (verticalSizeClass: UIUserInterfaceSizeClass){
        if(verticalSizeClass == .Compact){
            stackView5.addArrangedSubview(devide)
            stackView3.insertArrangedSubview(sqrt, atIndex: 0)
            stackView2.insertArrangedSubview(e, atIndex: 0)
            stackView1.insertArrangedSubview(pi, atIndex: 0)
            stackView0.insertArrangedSubview(tan, atIndex: 0)
            stackView4.hidden = true
        } else {
            stackView4.addArrangedSubview(tan)
            stackView0.removeArrangedSubview(tan)
            stackView4.addArrangedSubview(pi)
            stackView1.removeArrangedSubview(pi)
            stackView4.addArrangedSubview(e)
            stackView2.removeArrangedSubview(e)
            stackView4.addArrangedSubview(sqrt)
            stackView3.removeArrangedSubview(sqrt)
            stackView4.addArrangedSubview(devide)
            stackView5.removeArrangedSubview(devide)
            stackView4.hidden = false
            
        }
    }
    
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if (digit != ".")||(textCurrentlyInDisplay.rangeOfString(".") == nil){
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    } 
    
    @IBAction func touchClear(sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        brain = CalculatorBrain()
        displayValue = nil
        sequenceОfОperandsОndОperations!.text = " "
        
    }
    
    @IBAction func touchBackspace(sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            let text = display.text!.substringToIndex(display.text!.endIndex.predecessor())
            if (text != "") {
                display.text = text
            } else {
                displayValue = brain.result
                userIsInTheMiddleOfTyping = false
            }            
        }
    }
    
    private var displayValue: Double? {
        get {
            if let text = display.text, value = numberFormatter.numberFromString(text) {
                return value.doubleValue
            }else{
                display.text! = " "
                return nil
            }
        }
        set {
            if let value = newValue{
                display.text = numberFormatter.stringFromNumber(value)
            }else{
                display.text = " "
            }
        }
    }

    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue ?? 0.0)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperand(mathematicalSymbol)
        }
        
        displayValue = brain.result
        sequenceОfОperandsОndОperations.text! = brain.description + (brain.isPartialResult ? " ..." : " =")

    }
}

