//
//  Enums.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 24/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import Foundation
import UIKit

enum UDKeys: String {
    case color
    case autoPlay
    
}

enum SegmentedColors: String {
    case Blue = "Blue"
    case Green = "Green"
    case Pink = "Pink"
    case Black = "Black"
    
   static let allValues = [Blue, Green, Pink, Black]
}

enum Margin {
    static let horizontal: CGFloat = 24
    static let verticalLarge: CGFloat = 24
    static let verticalVeryLarge: CGFloat = 72
}

class UserDefaultsManager {
    static var defaults = UserDefaults.standard
    
    class func setColor(to colorNumber: Int) {
        defaults.set(colorNumber, forKey: UDKeys.color.rawValue)
        defaults.synchronize()
    }
    
    class func colorNumber() -> Int {
        return defaults.integer(forKey: UDKeys.color.rawValue)
    }
    
    class func setAutoPlay(to isOn: Bool) {
        defaults.set(isOn, forKey: UDKeys.autoPlay.rawValue)
        defaults.synchronize()
    }
    
    class func autoPlay() -> Bool {
        return defaults.bool(forKey: UDKeys.autoPlay.rawValue)
    }
    
    class func synchronize() {
        defaults.synchronize()
    }
}
