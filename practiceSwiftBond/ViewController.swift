//
//  ViewController.swift
//  practiceSwiftBond
//
//  Created by Fumiya Yamanaka on 2016/06/26.
//  Copyright © 2016年 yamanaka fumiya. All rights reserved.
//

import UIKit
import Bond

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var requestIndicator: UIActivityIndicatorView!
    @IBOutlet weak var agreementSwitch: UISwitch!
    @IBOutlet weak var warningLabel: UILabel!
    
    var signUpVM = SignUpVM()
    
    private func setUpBind() {
        signUpVM.loginID.bidirectionalBindTo(loginTextField.bnd_text)
        signUpVM.password.bidirectionalBindTo(passwordTextField.bnd_text)
        signUpVM.passwordConfirmation.bidirectionalBindTo(passwordConfirmationTextField.bnd_text)
        signUpVM.isAgreement.bidirectionalBindTo(agreementSwitch.bnd_on)
        
        signUpVM.signUPViewStateInfo.observe{ [weak self] (buttonEnabled, buttonAlpha, warningMessage) -> Void in
            self?.warningLabel.text = warningMessage
            self?.submitButton.enabled = buttonEnabled
            self?.submitButton.alpha = buttonAlpha
        }
        
        signUpVM.isLoadingViewHidden.bindTo(requestIndicator.bnd_hidden)
        signUpVM.isLoadingViewAnimate.bindTo(requestIndicator.bnd_animating)
        
        submitButton.bnd_controlEvent.filter { $0 == .TouchUpInside }
            .observe { [weak self] _ -> Void in
                self?.signUpVM.signUp()
        }
        
        
        signUpVM.finishSignUp.ignoreNil().observe { [weak self] (id, password) -> Void in
            let alertController = UIAlertController(title: "メッセージ", message: "loginID:\(id)\npassword:\(password)", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(action)
            self?.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBind()
    }

}
