//
//  CustomImageView.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 06/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import UIKit
import Foundation


class CustomImageView: UIImageView {
    
    override var image: UIImage? {
        didSet {
            layer.borderWidth = CGFloat(1.0)
            let borderColor: UIColor = .white
            layer.borderColor = borderColor.cgColor
            
            let cornerRadius: CGFloat = frame.size.height / 2
            layer.cornerRadius = cornerRadius
        }
    }
    
}
