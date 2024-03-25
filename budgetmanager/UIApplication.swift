//
//  UIApplication.swift
//  budgetmanager
//
//  Created by Kiss Roland on 2023. 05. 29..
//

import SwiftUI


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

