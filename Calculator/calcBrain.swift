//
//  calcBrain.swift
//  Calculator
//
//  Created by Tyler Wagner on 1/11/17.
//  Copyright © 2017 Tyler Wagner. All rights reserved.
//

import Foundation

func memAdd(num: Double, mem: Double) -> Double{return mem + num}
func memSub(num: Double, mem: Double) -> Double{ return mem - num}
func memClear(num: Double, mem: Double) -> Double{return 0.0}
func getMem(mem: Double) -> Double{return mem}

class CalcBrain{
    private var accumulator = 0.0
    private var memory = 0.0
    private var pending: pendingBinOperation?
    
        func setOperand(operand: Double){
        accumulator = operand
    }
    
    enum Operation{
        case Constant(Double)
        case UnaryOperator((Double)->Double)
        case BinaryOperator((Double, Double) -> Double)
        case MemoryOperation((Double, Double) -> Double)
        case ReturnMemory((Double)->Double)
        case Equals
    }
    
    var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "M": Operation.ReturnMemory(getMem),
        "√": Operation.UnaryOperator(sqrt),
        "cos": Operation.UnaryOperator(cos),
        "±": Operation.UnaryOperator({-$0}),
        "x^2": Operation.UnaryOperator({pow($0, 2)}),
        "-M": Operation.MemoryOperation(memSub),
        "+M": Operation.MemoryOperation(memAdd),
        "MC": Operation.MemoryOperation(memClear),
        "×": Operation.BinaryOperator({$0 * $1}),
        "÷": Operation.BinaryOperator({$0 / $1}),
        "+": Operation.BinaryOperator({$0 + $1}),
        "−": Operation.BinaryOperator({$0 - $1}),
        "=": Operation.Equals
    ]
    
    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value): accumulator = value
            case .UnaryOperator(let function): accumulator = function(accumulator)
            case .BinaryOperator(let function): pending = pendingBinOperation(binFunction: function, firstOperand: accumulator)
            case .MemoryOperation(let function): memory = function(accumulator, memory)
            case .ReturnMemory(let function): accumulator = function(memory)
            case .Equals: exePendingBinOperation()
            }
        }
    }
    
    private func exePendingBinOperation(){
        if pending != nil{
            accumulator = pending!.binFunction(pending!.firstOperand, accumulator)
            pending = nil
        }

    }

    
    struct pendingBinOperation {
        var binFunction: (Double, Double) ->Double
        var firstOperand: Double
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
}