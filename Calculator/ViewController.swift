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
            if let text = display.text, value = Double(text) {
                return Double(value)
            }else{
                display.text! = " "
                return nil
            }
        }
        set {
            if let value = newValue{
                display.text = String(value)
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

