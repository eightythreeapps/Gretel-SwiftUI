//
//  Instantiable.swift
//  Gretel
//
//  Created by Ben Reed on 06/04/2023.
//

import Foundation
import CoreData

protocol Instantiable {
    static func newInstance<T:NSManagedObject>(type:T.Type, moc: NSManagedObjectContext) -> T?
}

extension Instantiable {
    
    static func newInstance<T:NSManagedObject>(type:T.Type, moc: NSManagedObjectContext) -> T? {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: self), in: moc) else{
            return nil
        }

        return T(entity: entityDescription, insertInto: moc)
        
    }
}
