//
//  DashboardLabelView.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 19/10/2022.
//

import SwiftUI

struct DashboardLabelView: View {
    
    var title:String
    var value:String
    var alignment:Alignment
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title3)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: alignment)
            Text(value)
                .font(.body)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: alignment)
        }
    }
}

struct DashboardLabelView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.DashboardLabelPreview()
    }
}
