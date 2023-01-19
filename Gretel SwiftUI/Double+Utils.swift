//
//  Double+Utils.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/01/2023.
//

import Foundation

extension Double {
    //https://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
