//
//  Ejercicios+CoreDataProperties.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 3/5/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//
//

import Foundation
import CoreData


extension Ejercicios {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ejercicios> {
        return NSFetchRequest<Ejercicios>(entityName: "Ejercicios")
    }

    @NSManaged public var aciertos: Int16
    @NSManaged public var fallos: Int16
    @NSManaged public var fecha: NSDate?
    @NSManaged public var tiempo: Int16
    @NSManaged public var ejerciciosUsuario: Usuarios?

}
