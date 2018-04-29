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
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    
    var userName: String?
    var currentUser: Usuarios?
    var stats: [Ejercicios] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ejerciciosTableView.delegate = self
        ejerciciosTableView.dataSource = self
        
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
        
        guard let ejercicios = currentUser?.usuarioEjercicios else{
            return 1
        }
        
        return ejercicios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEjercicios", for: indexPath)
        
        guard let ejercicio = currentUser?.usuarioEjercicios?.allObjects[indexPath.row] as? Ejercicios, let founded = ejercicio.aciertos as? Int16, let failed = ejercicio.fallos as? Int16, let date = ejercicio.fecha as Date?, let time = ejercicio.tiempo as? Int16 else {
            return cell
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "es_ES")
        
        stats.append(ejercicio)
        
        cell.textLabel?.text = "Founded: \(founded)/6\t\t\t Failed: \(failed)\t\t\t Spent time: \(time) seconds"
        cell.detailTextLabel?.text = dateFormatter.string(from: date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
            managedContext.delete(stats[indexPath.row])
            stats.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error al borrar el ejercicio: \(error), \(error.userInfo)")
            }
            ejerciciosTableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
