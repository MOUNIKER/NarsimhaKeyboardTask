//
//  ViewController.swift
//  KeyboardTask
//
//  Created by Narasimha on 27/06/23.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
     
     @IBOutlet weak var textField: UITextField!
     override func viewDidLoad() {
          super.viewDidLoad()
          textField.becomeFirstResponder()
     }
}
