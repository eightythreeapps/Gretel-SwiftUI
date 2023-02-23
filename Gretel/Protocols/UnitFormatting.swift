//
//  UnitFormatting.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 09/02/2023.
//

import Foundation

public protocol UnitFormatting  {
    func formatDistance(distanceInMetres:Double, granularity:UnitGranularity) -> String
}
