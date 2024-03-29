//
//  SignUpViewModel.swift
//  BestMoovies
//
//  Created by Alexander Evdakov on 9/26/19.
//  Copyright © 2019 Alexander Evdakov. All rights reserved.
//

import UIKit.UITextField

final class SignUpViewModel {
    var signUpFormModel: SignUpFormModel = SignUpFormModel()
    
    func validateAndSaveData(_ textField: UITextField, _ fullNameErrorLabel: UILabel, _ phoneNumberErrorLabel: UILabel, _ emailAddressErrorField: UILabel, _ passwordErrorLabel: UILabel) {
        switch textField.accessibilityIdentifier {
        case AccessibilityIdentifiers.signUpFullNameIdentifier:
            signUpFormModel.isFullNameFieldValid = FormsHelper.handleFieldStatement(textField: textField, fieldLabel: fullNameErrorLabel, validationType: ValidatorType.fullName)
            signUpFormModel.fullName = textField.text
        case AccessibilityIdentifiers.signUpPhoneNumberIdentifier:
            signUpFormModel.isPhoneNumberFieldValid = FormsHelper.handleFieldStatement(textField: textField, fieldLabel: phoneNumberErrorLabel, validationType: ValidatorType.phoneNumber)
            signUpFormModel.phoneNumber = textField.text
        case AccessibilityIdentifiers.signUpEmailAddressIdentifier:
            signUpFormModel.isEmailAddressFieldValid = FormsHelper.handleFieldStatement(textField: textField, fieldLabel: emailAddressErrorField, validationType: ValidatorType.email)
            signUpFormModel.emailAddress = textField.text
        case AccessibilityIdentifiers.signUpPasswordIdentifier:
            signUpFormModel.isPasswordFieldValid = FormsHelper.handleFieldStatement(textField: textField, fieldLabel: passwordErrorLabel, validationType: ValidatorType.password)
            signUpFormModel.password  = textField.text
        default:
            break
        }
    }
    
    func isFormValid() -> Bool {
        return [signUpFormModel.isFullNameFieldValid!, signUpFormModel.isPhoneNumberFieldValid!, signUpFormModel.isEmailAddressFieldValid!, signUpFormModel.isPasswordFieldValid!].allSatisfy({ $0 == true })
    }
    
    func createAccount(button: UIButton, activityIndicator: UIActivityIndicatorView, completionBlock: @escaping (_ success: Bool) -> Void) {
        let signUpManager = FirebaseAuthManager()
        
        let fullName = signUpFormModel.fullName
        let phoneNumber = signUpFormModel.phoneNumber
        
        if let email = signUpFormModel.emailAddress, let password = signUpFormModel.password {
            signUpManager.createUser(email: email, password: password) { result in
                ActivityIndicatorHelper.deleteIndicatorFromButton(button, "Create Account", activityIndicator)
                
                if result {
                    self.saveUserData(fullName!, phoneNumber!, email)
                }
                
                completionBlock(result)
            }
        }
    }
    
    func saveUserData(_ fullName: String, _ phoneNumber: String, _ email: String) {
        let coreDataManager = UserCoreDataManager()
        coreDataManager.createNewUser(fullName, phoneNumber, email)
    }
    
}
