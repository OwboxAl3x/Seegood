//
//  Evento+CoreDataProperties.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 9/5/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//
//

import Foundation
import CoreData


extension Evento {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Evento> {
        return NSFetchRequest<Evento>(entityName: "Evento")
    }

    @NSManaged public var fecha: NSDate?
    @NSManaged public var nombreEvento: String?
    @NSManaged public var eventoUsuario: Usuarios?

}
