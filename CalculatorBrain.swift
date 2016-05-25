//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ilya Dolgopolov on 22.05.16.
//  Copyright © 2016 Ilya Dolgopolov. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var accumulatorDescription = " "
    
    deinit {
        print("killed!")
    }
    
    var description: String {
        if pending == nil{
            return accumulatorDescription
        } else {
            //print("accumulatorDescription equals \(accumulatorDescription) and firstOperandDescription \(pending!.firstOperandDescription)")
            return pending!.stringFunction(pending!.firstOperandDescription, pending!.firstOperandDescription != accumulatorDescription ? accumulatorDescription : "")
        }
    }
    
    var isPartialResult: Bool {
        return pending != nil
    }
    
    func setOperand(operand: Double){
        accumulator = operand
        accumulatorDescription = Formatter.numberFormatter.stringFromNumber(accumulator) ?? " "
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "ln" : Operation.UnaryOperation(log, {"ln("+$0+")"}),
        "√" : Operation.UnaryOperation(sqrt,{"√("+$0+")"}),
        "±" : Operation.UnaryOperation({-$0},{"-("+$0+")"}),
        "cos" : Operation.UnaryOperation(cos,{"cos("+$0+")"}),
        "sin" : Operation.UnaryOperation(sin,{"sin("+$0+")"}),
        "tan" : Operation.UnaryOperation(tan,{"tan("+$0+")"}),
        "cos⁻¹" : Operation.UnaryOperation(acos,{"cos⁻¹("+$0+")"}),
        "sin⁻¹" : Operation.UnaryOperation(asin,{"sin⁻¹("+$0+")"}),
        "tan⁻¹" : Operation.UnaryOperation(atan,{"tan⁻¹("+$0+")"}),
        "10ˣ" : Operation.UnaryOperation({pow(10.0,$0)},{"10 ^ "+$0}),
        "×" : Operation.BinaryOperation({$0 * $1}, {$0 + " × " + $1}),
        "×ʸ" : Operation.BinaryOperation({pow($0,$1)},{$0 + " ^ " + $1}),
        "÷" : Operation.BinaryOperation({$0 / $1},{$0 + " ÷ " + $1}),
        "+" : Operation.BinaryOperation({$0 + $1},{$0 + " + " + $1}),
        "-" : Operation.BinaryOperation({$0 - $1},{$0 + " - " + $1}),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double,Double) -> Double, (String, String) -> String)
        case Equals
    }
    
    func performOperand(symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
                accumulatorDescription = symbol
            case .UnaryOperation(let function,let stringFunction):
                accumulator = function(accumulator)
                accumulatorDescription = stringFunction(accumulatorDescription)
            case .BinaryOperation(let function, let stringFunction):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunftion: function, firstOperand: accumulator, stringFunction: stringFunction, firstOperandDescription: accumulatorDescription)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunftion(pending!.firstOperand,accumulator)
            accumulatorDescription = pending!.stringFunction(pending!.firstOperandDescription, accumulatorDescription)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunftion: (Double, Double) -> Double
        var firstOperand: Double
        var stringFunction: (String, String) -> String
        var firstOperandDescription: String
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    //let formatter = Formatter.numberFormatter.stringFromNumber(123.545555454545454545454)
}

class Formatter{
    static let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 6
        formatter.groupingSeparator = " "
        return formatter
    }()
}