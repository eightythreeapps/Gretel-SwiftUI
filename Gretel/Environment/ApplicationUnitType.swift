//
//  ApplicationUnitType.swift
//  Gretel
//
//  Created by Ben Reed on 16/02/2023.
//

import SwiftUI

private struct ApplicationUnitType: EnvironmentKey {
    static let defaultValue = UnitType.metric
}

extension EnvironmentValues {
  var activeUnitType: UnitType {
    get { self[ApplicationUnitType.self] }
    set { self[ApplicationUnitType.self] = newValue }
  }
}
