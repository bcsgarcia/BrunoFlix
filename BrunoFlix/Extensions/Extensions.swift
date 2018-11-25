//
//  Extensions.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 07/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    var titleUrl : String {
        var title = ""
        if let text = self.text {
            title = text.lowercased().replacingOccurrences(of: " ", with: "+")
        }
       return title
    }
    
    
}


