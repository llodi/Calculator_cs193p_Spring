//
//  ViewController.swift
//  Calculator
//
//  Created by Ilya Dolgopolov on 21.05.16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {


    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet weak var sequenceОfОperandsОndОperations: UILabel!
    
    private var userIsInTheMiddleOfTyping = false

    @IBOutlet weak var u: UIButton!
    @IBOutlet weak var log: UIButton!
    @IBOutlet weak var tenx: UIButton!
    @IBOutlet weak var ln: UIButton!
    @IBOutlet weak var tan_1: UIButton!
    @IBOutlet weak var c: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var M: UIButton!
    @IBOutlet weak var setM: UIButton!
    @IBOutlet weak var rand: UIButton!
    
    @IBOutlet weak var stackView0: UIStackView!
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var stackView5: UIStackView!
    @IBOutlet weak var stackView6: UIStackView!

    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        reArrangedViewStacks(newCollection.verticalSizeClass)
    }
    
    private func reArrangedViewStacks (verticalSizeClass: UIUserInterfaceSizeClass){
        if(verticalSizeClass == .Compact){
            stackView4.addArrangedSubview(c)
            stackView3.addArrangedSubview(back)
            stackView2.addArrangedSubview(M)
            stackView1.addArrangedSubview(setM)
            stackView0.addArrangedSubview(rand)
            stackView4.insertArrangedSubview(u, atIndex: 0)
            stackView3.insertArrangedSubview(log, atIndex: 0)
            stackView2.insertArrangedSubview(tenx, atIndex: 0)
            stackView1.insertArrangedSubview(ln, atIndex: 0)
            stackView0.insertArrangedSubview(tan_1, atIndex: 0)
            stackView5.hidden = true
            stackView6.hidden = true
        } else {
            stackView6.addArrangedSubview(rand)
            stackView6.addArrangedSubview(setM)
            stackView6.addArrangedSubview(M)
            stackView6.addArrangedSubview(back)
            stackView6.addArrangedSubview(c)
            stackView5.addArrangedSubview(tan_1)
            stackView5.addArrangedSubview(ln)
            stackView5.addArrangedSubview(tenx)
            stackView5.addArrangedSubview(log)
            stackView5.addArrangedSubview(u)
            stackView5.hidden = false
            stackView6.hidden = false
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
        //brain.clear()
        displayValue = nil
        sequenceОfОperandsОndОperations!.text = " "
        
    }
    
    private var variableTitle = ""
    
    @IBAction func touchBackspace() {
        if userIsInTheMiddleOfTyping{
            let text = display.text!.substringToIndex(display.text!.endIndex.predecessor())
            if (text != "") {
                display.text = text
            } else {
                displayValue = brain.result
                userIsInTheMiddleOfTyping = false
            }            
        } else {
            brain.undo()
            displayValue = brain.result
        }
    }
   
    private var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func touchVariable(sender: UIButton) {
        variableTitle = sender.currentTitle ?? "x"
        brain.setOperand(variableTitle)
        displayValue = brain.result
    }
    
    @IBAction func setValueInVariable(sender: AnyObject) {
        brain.variableValues[variableTitle] = displayValue
        savedProgram = brain.program
        userIsInTheMiddleOfTyping = false
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
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

