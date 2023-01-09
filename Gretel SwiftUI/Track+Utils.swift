//
//  Track+Utils.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 11/11/2022.
//

import Foundation

extension Track {
    
    func displayName() -> String {
        if let name = self.name {
            return name
        }
        
        return "No name"
    }
    
    func formattedDistance() -> String {
        return "10.0km"
    }
    
    func formattedDuration() -> String {
        return "2:04:23"
    }
    
}
