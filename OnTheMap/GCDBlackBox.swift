//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Molly Cox on 10/18/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    func performUIUpdatesOnMain(updates: @escaping () -> Void) {
        DispatchQueue.main.async{
            updates()
        }
    }
}
