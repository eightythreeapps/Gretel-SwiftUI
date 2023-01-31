//
//  Device.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 31/01/2023.
//

import SwiftUI

extension UIDevice {
    
    public static var isPad:Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
}
