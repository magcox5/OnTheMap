//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Molly Cox on 10/18/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var attemptingLogin: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!
    var udacityClient: UdacityClient!
    var keyboardOnScreen = false
    
    // MARK:  Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var debugLabel: UILabel!
    
    @IBAction func signUpButton(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: UdacityClient.Constants.signupURL)! as URL, options: [:], completionHandler: nil)    }
    

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        configureUI()
        
        subscribeToNotification(NSNotification.Name.UIKeyboardWillShow.rawValue, selector: #selector(keyboardWillShow))
        subscribeToNotification(NSNotification.Name.UIKeyboardWillHide.rawValue, selector: #selector(keyboardWillHide))
        subscribeToNotification(NSNotification.Name.UIKeyboardDidShow.rawValue, selector: #selector(keyboardDidShow))
        subscribeToNotification(NSNotification.Name.UIKeyboardDidHide.rawValue, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }


    // MARK:  Login
    @IBAction func loginPressed(_ sender: AnyObject) {

        userDidTapView(self)
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugLabel.text = "Username or Password Empty."
        } else {
            setUIEnabled(false)
            attemptingLogin.isHidden = false
            attemptingLogin.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            attemptingLogin.startAnimating()
            UdacityClient.sharedInstance().authenticateWithViewController(self, userName: usernameTextField.text!, password: passwordTextField.text!, completionHandlerForAuth: { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.displayError(errorString!)
                    }
                }
            })
        }
    }
    
    fileprivate func completeLogin() {
        performUIUpdatesOnMain {
            self.debugLabel.text = ""
            self.setUIEnabled(true)
            self.attemptingLogin.isHidden = true
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }

}
    // MARK: - LoginViewController: UITextFieldDelegate
    
    extension LoginViewController: UITextFieldDelegate {
        
        // MARK: UITextFieldDelegate
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        // MARK: Show/Hide Keyboard
        
        func keyboardWillShow(_ notification: Notification) {
            if !keyboardOnScreen {
                view.frame.origin.y -= keyboardHeight(notification)
            }
        }
        
        func keyboardWillHide(_ notification: Notification) {
            if keyboardOnScreen {
                view.frame.origin.y += keyboardHeight(notification)
            }
        }
        
        func keyboardDidShow(_ notification: Notification) {
            keyboardOnScreen = true
        }
        
        func keyboardDidHide(_ notification: Notification) {
            keyboardOnScreen = false
        }
        
        fileprivate func keyboardHeight(_ notification: Notification) -> CGFloat {
            let userInfo = (notification as NSNotification).userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            return keyboardSize.cgRectValue.height
        }
        
        fileprivate func resignIfFirstResponder(_ textField: UITextField) {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
        }
        
        @IBAction func userDidTapView(_ sender: AnyObject) {
            resignIfFirstResponder(usernameTextField)
            resignIfFirstResponder(passwordTextField)
        }
    }

    // MARK: - LoginViewController (Configure UI)
    
    extension LoginViewController {
        
        fileprivate func setUIEnabled(_ enabled: Bool) {
            usernameTextField.isEnabled = enabled
            passwordTextField.isEnabled = enabled
            loginButton.isEnabled = enabled
            debugLabel.text = ""
            debugLabel.isEnabled = enabled
            
            // adjust login button alpha
            if enabled {
                loginButton.alpha = 1.0
            } else {
                loginButton.alpha = 0.5
            }
        }
        

    fileprivate func configureUI() {
        
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [UdacityClient.UI.LoginColorTop, UdacityClient.UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        configureTextField(usernameTextField!)
        configureTextField(passwordTextField!)
        
        attemptingLogin.isHidden = true
    }
    
    fileprivate func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UdacityClient.UI.GreyColor
        textField.textColor = UdacityClient.UI.BlueColor
        textField.tintColor = UdacityClient.UI.BlueColor
        textField.delegate = self
    }
 
        // MARK:  Error Checking
        // if an error occurs, pop up an alert view and re-enable the UI
        public func displayError(_ error: String) {
            
            let nextController = UIAlertController()
            let okAction = UIAlertAction(title: error, style: UIAlertActionStyle.default){ action in self.dismiss(animated: true, completion: nil)}
            
            nextController.addAction(okAction)
            
            self.present(nextController, animated:  true, completion:nil)
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                self.attemptingLogin.isHidden = true
            }
        }
        
}

// MARK: - LoginViewController (Notifications)

extension LoginViewController {
    
    fileprivate func subscribeToNotification(_ notification: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: notification), object: nil)
    }
    
    fileprivate func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    

}



