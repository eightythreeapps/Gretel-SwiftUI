//
//  SettingsView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 30/01/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settingsService:SettingsService
    
    var body: some View {
        List {
            
            Section {
                ForEach(UnitType.allCases){ unitType in
                    HStack {
                        Text(unitType.displayValue())
                        Spacer()
                        if unitType == settingsService.unitType {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .onTapGesture {
                        settingsService.updateUnitType(unitType: unitType)
                    }
                }
            } header: {
                Text("Units")
            } footer: {
                Text(settingsService.unitType.displayMessage())
            }

            
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeSettingsView()
    }
}
