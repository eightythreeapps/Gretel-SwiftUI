//
//  DisplayFormatting.swift
//  Gretel
//
//  Created by Ben Reed on 20/02/2023.
//

import Foundation

protocol DisplayFormatting {
    func toString() -> String
}

extension DisplayFormatting {
    func toString() -> String {
        return "\(self)"
    }
}
