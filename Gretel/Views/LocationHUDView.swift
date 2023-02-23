//
//  TrackRecorderHUDView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/01/2023.
//

import SwiftUI

struct LocationHUDView: View {
    
    var latitude:String = "0.0"
    var longitude:String = "0.0"
    var altitude:String = "0.0"
    var speed:String = "4mph"
    
    @EnvironmentObject var locationRecorder:LocationRecorderService
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            HStack {
                HUDLabelView(title: "Lat", value: latitude)
                HUDLabelView(title: "Lon", value: longitude)
                HUDLabelView(title: "Altitude", value: altitude)
                HUDLabelView(title: "Speed", value: altitude)
            }
            
        }
    }
}


struct TrackRecorderHUDView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeTrackRecorderHUDPreview()
    }
}

struct HUDLabelView: View {
    
    var title:String
    var value:String
    var horizontalAlightment:HorizontalAlignment = .center
    
    var body: some View {
        VStack(alignment: horizontalAlightment) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(uiColor: .label))
            Text(value)
                .font(.subheadline)
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
        .padding(EdgeInsets(top: 8.0,
                            leading: 12.0,
                            bottom: 8.0,
                            trailing: 12.0))
        
    }
}
