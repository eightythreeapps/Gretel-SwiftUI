//
//  UnitGranularity.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 09/02/2023.
//

import Foundation

public enum UnitGranularity {
    case small
    case large
    
    func suffix(type:UnitType) -> String {
        
        switch self {
        case .small:
            if type == .imperial {
                return "ft"
            }else{
                return "M"
            }
        case .large:
            if type == .imperial {
                return "m"
            }else{
                return "km"
            }
        }
        
    }
    
}
