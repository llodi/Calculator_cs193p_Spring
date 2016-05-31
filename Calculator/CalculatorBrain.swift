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
    private var currentPrecedence = 0
    var variableValues: Dictionary<String, Double> = [:]
    
    private var internalProgram = [AnyObject]()
    
    deinit {
        print("killed!")
    }
    
    var description: String {
        if pending == nil{
            return accumulatorDescription
        } else {
            return pending!.stringFunction(pending!.firstOperandDescription, pending!.firstOperandDescription != accumulatorDescription ? accumulatorDescription 	: "")
        }
    }
    
    var isPartialResult: Bool {
        return pending != nil
    }
    
    func setOperand(variableName: String){
        internalProgram.append(variableName)
        accumulator = variableValues[variableName] ?? 0.0
        accumulatorDescription = variableName
    }
    
    func setOperand(operand: Double){
        internalProgram.append(operand)
        accumulator = operand
        accumulatorDescription = numberFormatter.stringFromNumber(accumulator) ?? " "
    }
    
    private var operations: Dictionary<String,Operation> = [
        "Rand" : Operation.noArgs(drand48, "rand"),
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "ln" : Operation.UnaryOperation(log, {"ln("+$0+")"}),
        "√" : Operation.UnaryOperation(sqrt,{"√("+$0+")"}),
        "±" : Operation.UnaryOperation({-$0},{"-("+$0+")"}),
        "cos" : Operation.UnaryOperation(cos,{"cos("+$0+")"}),
        "sin" : Operation.UnaryOperation(sin,{"sin("+$0+")"}),
        "tan" : Operation.UnaryOperation(tan,{"tan("+$0+")"}),
        "log" : Operation.UnaryOperation(log,{"log("+$0+")"}),
        "log₁₀" : Operation.UnaryOperation(log10,{"log₁₀("+$0+")"}),
        "cos⁻¹" : Operation.UnaryOperation(acos,{"cos⁻¹("+$0+")"}),
        "sin⁻¹" : Operation.UnaryOperation(asin,{"sin⁻¹("+$0+")"}),
        "tan⁻¹" : Operation.UnaryOperation(atan,{"tan⁻¹("+$0+")"}),
        "10ˣ" : Operation.UnaryOperation({pow(10.0,$0)},{"10 ^ "+$0}),
        "×" : Operation.BinaryOperation({$0 * $1}, {$0 + " × " + $1},0),
        "×ʸ" : Operation.BinaryOperation({pow($0,$1)},{$0 + " ^ " + $1},0),
        "÷" : Operation.BinaryOperation({$0 / $1},{$0 + " ÷ " + $1},0),
        "+" : Operation.BinaryOperation({$0 + $1},{$0 + " + " + $1},2),
        "-" : Operation.BinaryOperation({$0 - $1},{$0 + " - " + $1},2),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case noArgs(()->Double, String)
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double,Double) -> Double, (String, String) -> String,Int)
        case Equals
    }
    
    func performOperand(symbol: String){
        internalProgram.append(symbol)
        if let operation = operations[symbol]{
            switch operation {
            case .noArgs(let noArgFunction, let noArgFunctionString):
                accumulator = noArgFunction()
                accumulatorDescription = noArgFunctionString
            case .Constant(let value):
                accumulator = value
                accumulatorDescription = symbol
            case .UnaryOperation(let function,let stringFunction):
                accumulator = function(accumulator)
                accumulatorDescription = stringFunction(accumulatorDescription)
            case .BinaryOperation(let function, let stringFunction, let precedence):
                executePendingBinaryOperation()
                if (currentPrecedence > precedence){
                    accumulatorDescription = "(" + accumulatorDescription + ")"
                }
                currentPrecedence = precedence
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
    
    func undo () {
        guard !internalProgram.isEmpty else {return}
        internalProgram.removeLast()
        print("\(internalProgram.count)")
        pending = nil
        program = internalProgram
        
        print("desscription: \(description) and acc \(accumulator)")
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set{
            //clear()
            //print("\(variableValues["M"])")
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let symbol = op as? String{
                        print("\(symbol)")
                        if (variableValues[symbol] != nil) {
                            setOperand(symbol)
                            continue
                        }
                        performOperand(symbol)
                    }
                }
            }
            
        }
    }
    
    func clear() {
        accumulator = 0.0
        accumulatorDescription = ""
        pending = nil
        variableValues = [:]
        currentPrecedence = 0
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}

let numberFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.locale = NSLocale.currentLocale()
    formatter.numberStyle = .DecimalStyle
    formatter.maximumFractionDigits = 6
    formatter.groupingSeparator = " "
    return formatter
}()
