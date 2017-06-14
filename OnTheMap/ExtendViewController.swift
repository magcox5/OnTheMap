//
//  ExtendViewController.swift
//  OnTheMap
//
//  Created by Molly Cox on 6/13/17.
//  Copyright © 2017 Molly Cox. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayError(errorString: String) {
        let nextController = UIAlertController()
        let okAction = UIAlertAction(title: "Error: \(String(describing: errorString)).", style: UIAlertActionStyle.default)
        nextController.addAction(okAction)
        self.present(nextController, animated:  true, completion:nil)
    }
    
}
