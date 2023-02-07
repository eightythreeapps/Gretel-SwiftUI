//
//  NSManagedObject+Utils.swift
//  Gretel SwiftUI
//
//  Created by Ben Reed on 02/02/2023.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    func save() throws {
        
        do {
            try self.managedObjectContext?.save()
        } catch let error as NSError {
            throw error
        }
        
    }
    
}
