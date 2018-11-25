//
//  Movie.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 05/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//
import Foundation
import CoreData

extension Movie {
    var strGenres: String {
        guard let localGenres = self.genres?.allObjects as? [Genre] else { return "" }
        let arrNames = localGenres.map{$0.name!}
        return arrNames.joined(separator: ", ")
    }
}
