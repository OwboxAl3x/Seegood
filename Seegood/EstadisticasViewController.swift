//
//  EstadisticasViewController.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 29/4/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//

import UIKit
import CoreData

class EstadisticasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ejerciciosTableView: UITableView!
    @IBOutlet weak var avTableView: UITableView!
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    
    var userName: String?
    var currentUser: Usuarios?
    var statsEj: [Ejercicios] = Array()
    var statsAV: [AgudezaVisual] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ejerciciosTableView.delegate = self
        ejerciciosTableView.dataSource = self
        
        avTableView.delegate = self
        avTableView.dataSource = self
        
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        let userFecth: NSFetchRequest<Usuarios> = Usuarios.fetchRequest()
        userFecth.predicate = NSPredicate(format: "%K == %@", #keyPath(Usuarios.nombre), self.userName!)
        
        do {
            let resultado = try managedContext.fetch(userFecth)
            
            if resultado.count > 0 {
                currentUser = resultado.first
            }
        } catch let error as NSError {
            print("El error fue: \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.ejerciciosTableView{
            guard let ejercicios = currentUser?.usuarioEjercicios else{
                return 1
            }
            return ejercicios.count
            
        } else {
            guard let avs = currentUser?.usuarioAV else{
                return 1
            }
            return avs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        
        if tableView == self.ejerciciosTableView{
            cell = tableView.dequeueReusableCell(withIdentifier: "cellEjercicios", for: indexPath)
            guard let ejercicio = currentUser?.usuarioEjercicios?.object(at: indexPath.row) as? Ejercicios, let founded = ejercicio.aciertos as? Int16, let failed = ejercicio.fallos as? Int16, let date = ejercicio.fecha as Date?, let time = ejercicio.tiempo as? Int16 else {
                return cell!
            }
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .medium
            dateFormatter.locale = Locale(identifier: "es_ES")
        
            statsEj.append(ejercicio)
        
            cell?.textLabel?.text = "Founded: \(founded)/6\t\t\t Failed: \(failed)\t\t\t Spent time: \(time) seconds"
            cell?.detailTextLabel?.text = dateFormatter.string(from: date)
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellAV", for: indexPath)
            guard let av = currentUser?.usuarioAV?.object(at: indexPath.row) as? AgudezaVisual, let ccOD = av.ccOjoDer as? Float, let ccOI = av.ccOjoIzq as? Float, let scOD = av.scOjoIzq as? Float, let scOI = av.scOjoDer as? Float, let date = av.fecha as Date? else {
                return cell!
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .medium
            dateFormatter.locale = Locale(identifier: "es_ES")
            
            statsAV.append(av)
            
            cell?.textLabel?.text = "With Compensation: OD: \(ccOD)\t OI: \(ccOI)\t\t\t Without Compensation: OD: \(scOD)\t OI: \(scOI)"
            cell?.detailTextLabel?.text = dateFormatter.string(from: date)
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.ejerciciosTableView{
            if editingStyle == .delete {
                let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
                managedContext.delete(statsEj[indexPath.row])
                statsEj.remove(at: indexPath.row)
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Error al borrar el ejercicio: \(error), \(error.userInfo)")
                }
                ejerciciosTableView.reloadData()
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        } else if tableView == self.avTableView{
            if editingStyle == .delete {
                let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
                managedContext.delete(statsAV[indexPath.row])
                statsAV.remove(at: indexPath.row)
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Error al borrar el AV: \(error), \(error.userInfo)")
                }
                avTableView.reloadData()
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        }
    }

}
