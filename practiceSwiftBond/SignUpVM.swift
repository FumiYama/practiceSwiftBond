//
//  signUpVM.swift
//  practiceSwiftBond
//
//  Created by Fumiya Yamanaka on 2016/06/26.
//  Copyright © 2016年 yamanaka fumiya. All rights reserved.

import UIKit
import Bond

class SignUpVM {
    
    enum RequestState {
        case None
        case Requesting
        case Success
        case Error
        
    }
    
    let requestState = Observable<RequestState>(.None)
    let loginID = Observable<String?>("")
    let password = Observable<String?>("")
    let passwordConfirmation = Observable<String?>("")
    let isAgreement = Observable<Bool>(false)
    
    var isLoadingViewAnimate: EventProducer<Bool> {
        return requestState.map { $0 == .Requesting }
    }
    
    var isLoadingViewHidden: EventProducer<Bool> {
        return requestState.map { $0 != .Requesting }
    }
    
    var finishSignUp: EventProducer<(id: String, password: String)?> {
        return requestState.map { [weak self] reqState in
            
            guard let id = self?.loginID.value, password = self?.password.value where reqState == .Success else {
                return nil
            }
            
            return (id, password)
        }
    }
    
    var signUPViewStateInfo: EventProducer<(buttonEnabled: Bool, buttonAlpha: CGFloat, warningMessage: String)> {
        
        return combineLatest(requestState, loginID, password, passwordConfirmation, isAgreement)
            .map{ (reqState, loginID, password, passwordConfirmation, isAgreement) in
        
                guard let loginID = loginID, password = password, passwordConfirmation = passwordConfirmation where reqState != .Requesting else {
                    return (false, 0.5, "")
                }

                if loginID.isEmpty || password.isEmpty || passwordConfirmation.isEmpty {
                    return (false, 0.5, "")
                }
                
                guard password.characters.count >= 8 || passwordConfirmation.characters.count >= 8 else {
                    return (false, 0.5, "パスワードは8文字以上入力してください")
                }
                
                guard password == passwordConfirmation else {
                    return (false, 0.5, "パスワードと確認パスワードが一致していません")
                }
                
                guard isAgreement else {
                    return (false, 0.5, "規約に同意してください")
                }
                
                return (true, 1.0, "")
        }
    }
    
    func signUp() {
        requestState.next(.Requesting)
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) { [unowned self] in
                self.requestState.next(.Success)
        }
    }

}

