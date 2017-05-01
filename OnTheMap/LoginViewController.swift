//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Molly Cox on 10/18/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import UIKit
import Foundation

// Global Variable
var studentUserID: String = ""
var studentFirstName: String = ""
var studentLastName: String = ""

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    // MARK:  Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    
    @IBAction func signUpButton(_ sender: Any) {
        
//    UIApplication.shared.openURL(NSURL(string: "https://auth.udacity.com/sign-up")! as URL)
        UIApplication.shared.open(NSURL(string: "https://auth.udacity.com/sign-up")! as URL, options: [:], completionHandler: nil)    }
    
    @IBOutlet weak var debugLabel: UILabel!
    
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
            
            getSessionID(username: usernameTextField.text!, password: passwordTextField.text!)
        }
        
    }
    
    fileprivate func completeLogin() {
        performUIUpdatesOnMain {
            self.debugLabel.text = ""
            self.setUIEnabled(true)
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }

    func getSessionID(username: String, password: String)
    {
        /* 1. Set the parameters */
        let methodParameters = [
            UdacityClient.ParameterKeys.ApiKey: UdacityClient.Constants.ApiKey
        ]
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)

        let session = URLSession.shared
        /* 4. Make the request */
        let task = appDelegate.sharedSession.dataTask(with: request, completionHandler: { (data, response, error) in
            
//            // MARK:  Error Checking
//            // if an error occurs, pop up an alert view and re-enable the UI
//            func displayError(_ error: String) {

//                let nextController = UIAlertController()
//                let okAction = UIAlertAction(title: error, style: UIAlertActionStyle.default){ action in self.dismiss(animated: true, completion: nil)}
                
//                nextController.addAction(okAction)
                
//                self.present(nextController, animated:  true, completion:nil)
//                performUIUpdatesOnMain {
//                    self.setUIEnabled(true)
//                }
//            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                self.displayError("There was an error with your request: \(String(describing: error))")
                print(error!)
                return
            }
            
            // Strip off 1st 5 characters in data
            let newData = (data! as NSData).subdata(with: NSMakeRange(5, (data?.count)! - 5))
            print(newData)
            
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject!
            } catch {
                self.displayError("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            
            /* GUARD: First, is there a session in our result? */
            guard let sessionData = parsedResult["session"] as? NSDictionary
                else {
                    self.displayError("Login Failed:  invalid username/password")
                    return
            }

            /* GUARD: Is there a session_id in our result? */
            guard let sessionID = sessionData[UdacityClient.ParameterKeys.SessionID] as? String
                else {
                    self.displayError("Cannot find key '\(UdacityClient.ParameterKeys.SessionID)'in \(parsedResult!)")
                    return
            }
            
            /* GUARD: Is there a userID in our result? */
            if let userData = parsedResult["account"] as? [String: AnyObject] {
                print(userData)
                let userID = userData["key"]
                print("My user id is:  \(userID!)")
                studentUserID = userID as! String
            }
            else {
                self.displayError("Cannot find userID in \(parsedResult!)")
                return
            }

            /* 6. Use the data! */
            print("Session Id is: \(sessionID)")
            self.appDelegate.sessionID = sessionID
            self.getUdacityName(userID: studentUserID)
            //self.completeLogin()
            
            /* 7. Start the request */
        }) 
        task.resume()
    }
    
    func getUdacityName(userID: String)
    {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)

            /* 5. Parse the data */
           let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                self.displayError("Could not parse udacity user data as JSON")
                return
            }

            /* GUARD: Is there a user in our result? */
            guard let userData = parsedResult["user"] as? [String: AnyObject]
            else {
                self.displayError("Cannot find 'user' in \(parsedResult)")
                return
            }
//                print(userData)
            let userInfo = userData["key"]
            print(userInfo as! [String: AnyObject])
            print("Yes, we have a user!")

            /* GUARD: Is there a last name in our result? */
            if let lastName = userInfo?["last_name"] as? String {
                print("My last name is:  \(lastName)")
                studentLastName = lastName            }
            else {
                self.displayError("Cannot find last name")
                return
            }
            

            /* GUARD: Is there a first name in our result? */
            if let firstName = userInfo?["first_name"] as? String {
                print("My first name is:  \(firstName)")
                studentFirstName = firstName
            }
            else {
                self.displayError("Cannot find first name")
                return
            }
            
            /* 6. Use the data! */
            self.completeLogin()
            
            /* 7. Start the request */

        }
        task.resume()
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



