//
//  UIViewHelper.swift
//  VenEcon2
//
//  Created by Girish Gupta on 14/12/2017.
//  Copyright © 2017 Girish Gupta. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviewAndFill(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
