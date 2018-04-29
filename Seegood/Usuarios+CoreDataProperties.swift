//
//  Usuarios+CoreDataProperties.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 29/4/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//
//

import Foundation
import CoreData


extension Usuarios {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuarios> {
        return NSFetchRequest<Usuarios>(entityName: "Usuarios")
    }

    @NSManaged public var cilindroOjoDer: Float
    @NSManaged public var cilindroOjoIzq: Float
    @NSManaged public var direccion: String?
    @NSManaged public var ejeOjoDer: Int16
    @NSManaged public var ejeOjoIzq: Int16
    @NSManaged public var esferaOjoDer: Float
    @NSManaged public var esferaOjoIzq: Float
    @NSManaged public var nombre: String?
    @NSManaged public var telefono: String?
    @NSManaged public var usuarioAV: NSSet?
    @NSManaged public var usuarioEjercicios: NSSet?

}

// MARK: Generated accessors for usuarioAV
extension Usuarios {

    @objc(addUsuarioAVObject:)
    @NSManaged public func addToUsuarioAV(_ value: AgudezaVisual)

    @objc(removeUsuarioAVObject:)
    @NSManaged public func removeFromUsuarioAV(_ value: AgudezaVisual)

    @objc(addUsuarioAV:)
    @NSManaged public func addToUsuarioAV(_ values: NSSet)

    @objc(removeUsuarioAV:)
    @NSManaged public func removeFromUsuarioAV(_ values: NSSet)

}

// MARK: Generated accessors for usuarioEjercicios
extension Usuarios {

    @objc(addUsuarioEjerciciosObject:)
    @NSManaged public func addToUsuarioEjercicios(_ value: Ejercicios)

    @objc(removeUsuarioEjerciciosObject:)
    @NSManaged public func removeFromUsuarioEjercicios(_ value: Ejercicios)

    @objc(addUsuarioEjercicios:)
    @NSManaged public func addToUsuarioEjercicios(_ values: NSSet)

    @objc(removeUsuarioEjercicios:)
    @NSManaged public func removeFromUsuarioEjercicios(_ values: NSSet)

}
