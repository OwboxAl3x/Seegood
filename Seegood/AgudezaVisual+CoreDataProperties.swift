//
//  AgudezaVisual+CoreDataProperties.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 29/4/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//
//

import Foundation
import CoreData


extension AgudezaVisual {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AgudezaVisual> {
        return NSFetchRequest<AgudezaVisual>(entityName: "AgudezaVisual")
    }

    @NSManaged public var ccOjoDer: Float
    @NSManaged public var ccOjoIzq: Float
    @NSManaged public var fecha: NSDate?
    @NSManaged public var scOjoDer: Float
    @NSManaged public var scOjoIzq: Float
    @NSManaged public var avUsuario: Usuarios?

}
