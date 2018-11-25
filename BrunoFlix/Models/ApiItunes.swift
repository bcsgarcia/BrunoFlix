//
//  ApiItunes.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 24/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import Foundation


struct ItunesApi: Codable {
    let resultCount: Int
    let results: [ItunesApiResults]
}

struct ItunesApiResults: Codable {
    let previewUrl: String
}
