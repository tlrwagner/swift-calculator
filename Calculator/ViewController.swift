//
//  ViewController.swift
//  Calculator
//
//  Created by Tyler Wagner on 1/10/17.
//  Copyright © 2017 Tyler Wagner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    private var userTypingNumber = false
    private let brain = CalcBrain()
    private var displayValue : Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPress(sender: UIButton) {
        let digit = sender.currentTitle!
        if userTypingNumber{
            let currentDisplayText = display.text!
            display.text = currentDisplayText + digit
        }else{
            display.text = digit
            userTypingNumber = true
        }
        
        print(sender.titleLabel!.text!)
    }
    
    @IBAction func operationButton(sender: UIButton) {
        if userTypingNumber{
            brain.setOperand(displayValue)
        }
        userTypingNumber = false
        if let mathSymbol = sender.currentTitle{
            brain.performOperation(mathSymbol)
        }
        displayValue = brain.result
    }
    
}

