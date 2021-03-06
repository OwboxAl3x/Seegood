//
//  MasterViewController.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 23/4/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class MasterViewController: UITableViewController {

    var detailViewController: ActivitiesViewController? = nil
    var usuarios:[Usuarios] = []
    var nombreUsuario:String?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Usuarios")
        
        do {
            usuarios = try managedContext.fetch(fetchRequest) as! [Usuarios]
        } catch let error as NSError {
            print("No se pudieron recuperar los datos guardados. El error fue: \(error), \(error.userInfo)")
        }
        
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewUser(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ActivitiesViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func insertNewUser(_ sender: Any) {
        
        let alertNewUser = UIAlertController(title: "New User", message: "Enter a username", preferredStyle: .alert)
        
        alertNewUser.addAction(UIAlertAction(title: "Add User", style: .default, handler: {
            alert -> Void in
            let fNameField = alertNewUser.textFields![0] as UITextField
            let lNameField = alertNewUser.textFields![1] as UITextField
            
            let nombreSinEspacio = fNameField.text?.trimmingCharacters(in: .whitespaces)
            let apellidosSinEspacio = fNameField.text?.trimmingCharacters(in: .whitespaces)
            
            if nombreSinEspacio != "", apellidosSinEspacio != "" {
                self.nombreUsuario = fNameField.text! + " " + lNameField.text!
                self.insertNewRow(nameUser: self.nombreUsuario!)
                self.tableView.reloadData()
            } else {
                
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.setMinimumDismissTimeInterval(1.5)
                SVProgressHUD.showError(withStatus: "Incorrect Fields")
                
            }
        }))
        
        alertNewUser.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action) in }))
        
        alertNewUser.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "First Name"
            textField.textAlignment = .center
        })
        
        alertNewUser.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Last Name"
            textField.textAlignment = .center
        })
        
        present(alertNewUser, animated: true, completion: nil)
        
    }
    
    func insertNewRow(nameUser: String) {
        
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        let entUsuarios = NSEntityDescription.insertNewObject(forEntityName: "Usuarios", into: managedContext) as! Usuarios
        
        entUsuarios.nombre = nameUser
        
        do {
            try managedContext.save()
            usuarios.append(entUsuarios)
        } catch let error as NSError {
            print("No se pudo añadir el nuevo usuario, error: \(error), \(error.userInfo)")
        }
        
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showActivities" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let usuario = usuarios[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! ActivitiesViewController
                controller.nameUser = usuario.nombre
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }else {
                if let split = splitViewController {
                    let controllers = split.viewControllers
                    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ActivitiesViewController
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let usuario = usuarios[indexPath.row]
        cell.textLabel!.text = usuario.value(forKey: "nombre") as? String
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
            managedContext.delete(usuarios[indexPath.row])
            usuarios.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error al borrar al usuario: \(error), \(error.userInfo)")
            }
            self.tableView.reloadData()
            
            if self.splitViewController?.viewControllers.count == 2 {
                self.performSegue(withIdentifier: "showActivities", sender: self)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

