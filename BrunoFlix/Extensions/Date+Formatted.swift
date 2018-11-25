//
//  Date+Formatted.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 16/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import Foundation

extension Date {
    var formatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    var formattedWithHour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        return dateFormatter.string(from: self)
    }
}
