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

    @IBOutlet weak var sin: UIButton!
    @IBOutlet weak var ln: UIButton!
    @IBOutlet weak var xy: UIButton!
    @IBOutlet weak var x10: UIButton!
    @IBOutlet weak var c: UIButton!
    @IBOutlet weak var atan: UIButton!
    @IBOutlet weak var pi: UIButton!
    @IBOutlet weak var e: UIButton!
    @IBOutlet weak var sqrt: UIButton!
    @IBOutlet weak var multi: UIButton!
    @IBOutlet weak var tan: UIButton!
    
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    
    
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
            if let text = display.text, value = Formatter.numberFormatter.numberFromString(text) {
                return value.doubleValue
            }else{
                display.text! = " "
                return nil
            }
        }
        set {
            if let value = newValue{
                display.text = Formatter.numberFormatter.stringFromNumber(value)
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

