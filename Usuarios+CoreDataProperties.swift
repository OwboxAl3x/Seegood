//
//  Usuarios+CoreDataProperties.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 9/5/18.
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
    @NSManaged public var cumple: NSDate?
    @NSManaged public var direccion: String?
    @NSManaged public var ejeOjoDer: Int16
    @NSManaged public var ejeOjoIzq: Int16
    @NSManaged public var esferaOjoDer: Float
    @NSManaged public var esferaOjoIzq: Float
    @NSManaged public var foto: NSData?
    @NSManaged public var nombre: String?
    @NSManaged public var telefono: String?
    @NSManaged public var usuarioAV: NSOrderedSet?
    @NSManaged public var usuarioEjercicios: NSOrderedSet?
    @NSManaged public var usuarioEvento: NSOrderedSet?

}

// MARK: Generated accessors for usuarioAV
extension Usuarios {

    @objc(insertObject:inUsuarioAVAtIndex:)
    @NSManaged public func insertIntoUsuarioAV(_ value: AgudezaVisual, at idx: Int)

    @objc(removeObjectFromUsuarioAVAtIndex:)
    @NSManaged public func removeFromUsuarioAV(at idx: Int)

    @objc(insertUsuarioAV:atIndexes:)
    @NSManaged public func insertIntoUsuarioAV(_ values: [AgudezaVisual], at indexes: NSIndexSet)

    @objc(removeUsuarioAVAtIndexes:)
    @NSManaged public func removeFromUsuarioAV(at indexes: NSIndexSet)

    @objc(replaceObjectInUsuarioAVAtIndex:withObject:)
    @NSManaged public func replaceUsuarioAV(at idx: Int, with value: AgudezaVisual)

    @objc(replaceUsuarioAVAtIndexes:withUsuarioAV:)
    @NSManaged public func replaceUsuarioAV(at indexes: NSIndexSet, with values: [AgudezaVisual])

    @objc(addUsuarioAVObject:)
    @NSManaged public func addToUsuarioAV(_ value: AgudezaVisual)

    @objc(removeUsuarioAVObject:)
    @NSManaged public func removeFromUsuarioAV(_ value: AgudezaVisual)

    @objc(addUsuarioAV:)
    @NSManaged public func addToUsuarioAV(_ values: NSOrderedSet)

    @objc(removeUsuarioAV:)
    @NSManaged public func removeFromUsuarioAV(_ values: NSOrderedSet)

}

// MARK: Generated accessors for usuarioEjercicios
extension Usuarios {

    @objc(insertObject:inUsuarioEjerciciosAtIndex:)
    @NSManaged public func insertIntoUsuarioEjercicios(_ value: Ejercicios, at idx: Int)

    @objc(removeObjectFromUsuarioEjerciciosAtIndex:)
    @NSManaged public func removeFromUsuarioEjercicios(at idx: Int)

    @objc(insertUsuarioEjercicios:atIndexes:)
    @NSManaged public func insertIntoUsuarioEjercicios(_ values: [Ejercicios], at indexes: NSIndexSet)

    @objc(removeUsuarioEjerciciosAtIndexes:)
    @NSManaged public func removeFromUsuarioEjercicios(at indexes: NSIndexSet)

    @objc(replaceObjectInUsuarioEjerciciosAtIndex:withObject:)
    @NSManaged public func replaceUsuarioEjercicios(at idx: Int, with value: Ejercicios)

    @objc(replaceUsuarioEjerciciosAtIndexes:withUsuarioEjercicios:)
    @NSManaged public func replaceUsuarioEjercicios(at indexes: NSIndexSet, with values: [Ejercicios])

    @objc(addUsuarioEjerciciosObject:)
    @NSManaged public func addToUsuarioEjercicios(_ value: Ejercicios)

    @objc(removeUsuarioEjerciciosObject:)
    @NSManaged public func removeFromUsuarioEjercicios(_ value: Ejercicios)

    @objc(addUsuarioEjercicios:)
    @NSManaged public func addToUsuarioEjercicios(_ values: NSOrderedSet)

    @objc(removeUsuarioEjercicios:)
    @NSManaged public func removeFromUsuarioEjercicios(_ values: NSOrderedSet)

}

// MARK: Generated accessors for usuarioEvento
extension Usuarios {

    @objc(insertObject:inUsuarioEventoAtIndex:)
    @NSManaged public func insertIntoUsuarioEvento(_ value: Evento, at idx: Int)

    @objc(removeObjectFromUsuarioEventoAtIndex:)
    @NSManaged public func removeFromUsuarioEvento(at idx: Int)

    @objc(insertUsuarioEvento:atIndexes:)
    @NSManaged public func insertIntoUsuarioEvento(_ values: [Evento], at indexes: NSIndexSet)

    @objc(removeUsuarioEventoAtIndexes:)
    @NSManaged public func removeFromUsuarioEvento(at indexes: NSIndexSet)

    @objc(replaceObjectInUsuarioEventoAtIndex:withObject:)
    @NSManaged public func replaceUsuarioEvento(at idx: Int, with value: Evento)

    @objc(replaceUsuarioEventoAtIndexes:withUsuarioEvento:)
    @NSManaged public func replaceUsuarioEvento(at indexes: NSIndexSet, with values: [Evento])

    @objc(addUsuarioEventoObject:)
    @NSManaged public func addToUsuarioEvento(_ value: Evento)

    @objc(removeUsuarioEventoObject:)
    @NSManaged public func removeFromUsuarioEvento(_ value: Evento)

    @objc(addUsuarioEvento:)
    @NSManaged public func addToUsuarioEvento(_ values: NSOrderedSet)

    @objc(removeUsuarioEvento:)
    @NSManaged public func removeFromUsuarioEvento(_ values: NSOrderedSet)

}
