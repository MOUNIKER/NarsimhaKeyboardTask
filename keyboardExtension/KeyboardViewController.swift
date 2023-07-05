//
//  KeyboardViewController.swift
//  keyboardExtension
//
//  Created by Narasimha on 27/06/23.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet weak var bottomBarResignKey: UIButton!
    @IBOutlet weak var sendOffer: UIButton!
    @IBOutlet weak var replaceButton: UIButton!
    @IBOutlet var shuffleBtn: [UIButton]!
    @IBOutlet weak var resignButton: UIButton!
    @IBOutlet weak var mainStackViewHeight: NSLayoutConstraint!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "NumberPad", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        view = objects[0] as? UIView
        shuffleNumberKeypad()
        buttonBorders()
        self.nextKeyboardButton = UIButton(type: .system)
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.view.addSubview(self.nextKeyboardButton)
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        applyConfiguration()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shuffleNumberKeypad()
    }
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    override func textWillChange(_ textInput: UITextInput?) {
        
    }
    override func textDidChange(_ textInput: UITextInput?) {
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    func buttonBorders()  {
        bottomBarResignKey.layer.borderWidth = 1
        bottomBarResignKey.layer.cornerRadius = 5
        sendOffer.layer.cornerRadius = 5
        shuffleBtn.forEach({
            $0.layer.cornerRadius = 5
        })
        replaceButton.layer.cornerRadius = 5
        resignButton.layer.cornerRadius = 5
    }
    func shuffleNumberKeypad() {
        let numbers = Array(0...9).shuffled()
        for (index, button) in shuffleBtn.enumerated() {
            let number = numbers[index]
            button.setTitle(String(number), for: .normal)
        }
    }
    @IBAction func returnButtontapped(_ sender: Any) {
        dismissKeyboard()
    }
    @IBAction func replaceButtonTapped(_ sender: Any) {
        if sendOffer.isHidden && bottomBarResignKey.isHidden {
            dismissKeyboard()
        }
        else{
            keyButtonTapped(sender: replaceButton)
        }
    }
    @IBAction func sendOfferButton(_ sender: Any) {
        dismissKeyboard()
    }
    @IBAction func keyButtonTapped(sender: UIButton) {
        let string = sender.titleLabel?.text
        (textDocumentProxy as UIKeyInput).insertText("\(string!)")
    }
    @IBAction func deleteButtonTapped(sender: UIButton) {
        textDocumentProxy.deleteBackward()
    }
    func applyConfiguration(){
        
        sendOffer.isHidden = !keyboardConfiguration.isBottomBarRequired
        bottomBarResignKey.isHidden = !keyboardConfiguration.isBottomBarRequired
        view.backgroundColor = keyboardConfiguration.keyboardBackgroundColor
        
        resignButton.backgroundColor = keyboardConfiguration.keyboardButtonBackgroundColor
        shuffleBtn.forEach({
            $0.backgroundColor = keyboardConfiguration.keyboardButtonBackgroundColor
            $0.setTitleColor(keyboardConfiguration.keyboardButtonForegroundColor, for: .normal)
        })
        
        if keyboardConfiguration.isBottomBarRequired {
            sendOffer.setTitle(keyboardConfiguration.buttomButtonText, for: .normal)
            sendOffer.backgroundColor = keyboardConfiguration.bottomButtonBackgroundColor
            sendOffer.setTitleColor(keyboardConfiguration.bottomButtonForegroundColor, for: .normal)
            bottomBarResignKey.tintColor = keyboardConfiguration.bottomButtonForegroundColor
            replaceButton.setTitle(".", for: .normal)
            replaceButton.titleLabel?.font = .boldSystemFont(ofSize: 10)
            
        }else {
            replaceButton.setTitle("", for: .normal)
            replaceButton.setImage(UIImage(named: "leftArrowImage.png")?.withTintColor(keyboardConfiguration.keyboardButtonForegroundColor, renderingMode: .alwaysOriginal), for: .normal)
        }
        resignButton.tintColor = keyboardConfiguration.keyboardButtonForegroundColor
        replaceButton.setTitleColor(keyboardConfiguration.keyboardButtonForegroundColor, for: .normal)
        replaceButton.backgroundColor = keyboardConfiguration.keyboardButtonBackgroundColor
        mainStackViewHeight.constant = keyboardConfiguration.isBottomBarRequired ? 94 : 10
        view.updateConstraintsIfNeeded()
    }
}

