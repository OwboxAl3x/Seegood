//
//  ExercisesViewController.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 29/4/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//

import UIKit
import CoreData

class ExercisesViewController: UIViewController {
    
    @IBOutlet var vista: UIView!
    @IBOutlet weak var vistaSec: UIView!
    @IBOutlet weak var labelAciertos: UILabel!
    @IBOutlet weak var labelFallos: UILabel!
    @IBOutlet weak var labelTouch: UILabel!
    
    @IBAction func doneButton(_ sender: UIButton) {
        terminado()
    }
    
    var userName: String?
    var currentUser: Usuarios?
    
    var anchoBoton: CGFloat?
    var altoBoton: CGFloat?
    var botones: [UIButton] = Array()
    var selectedLetter: String?
    var letraPuesta:Int = 0
    var aciertos: Int = 0
    var fallos: Int = 0
    var aciertosTotales: Int = 6
    
    var primeraPulsación: Bool = true
    
    var startTime: CFTimeInterval?
    var endTime: CFTimeInterval?
    var totalTime: CFTimeInterval?
    
    func crearBotones() {
        
        var buttonX: CGFloat = 0
        var buttonY: CGFloat = 135
        for _ in 0...3 {
            for _ in 0...5 {
                
                let boton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: anchoBoton!, height: altoBoton!))
                botones.append(boton)
                buttonX = buttonX + anchoBoton!
                boton.setTitleColor(UIColor.black, for: .normal)
                boton.setTitle(randomString(length: 1), for: .normal)
                if boton.titleLabel?.text == selectedLetter {
                    letraPuesta += 1
                }
                boton.addTarget(self, action: #selector(botonPressed), for: .touchUpInside)
                
                self.view.addSubview(boton)  // myView in this case is the view you want these buttons added
            }
            buttonY = buttonY + altoBoton!
            buttonX = 0
        }
    }
    
    @objc func botonPressed(sender:UIButton!){
        if primeraPulsación == true {
            startTime = CACurrentMediaTime()
            primeraPulsación = false
        }
        if sender.titleLabel?.text == selectedLetter {
            aciertos += 1
            labelAciertos.text = "Found: \(aciertos)/\(aciertosTotales)"
            sender.isHidden = true
            if aciertos == aciertosTotales {
                terminado()
            }
        } else {
            fallos += 1
            labelFallos.text = "Failures: \(fallos)"
        }
    }
    
    func terminado() {
        endTime = CACurrentMediaTime()
        if startTime != nil {
            totalTime = endTime! - startTime!
        } else {
            totalTime = 0.0
        }
        
        let alertFinalized = UIAlertController(title: "Finalized", message: labelAciertos.text! + "\n" + labelFallos.text! + "\nTime elapsed: \(Int(totalTime!)) seconds", preferredStyle: .alert)
        
        alertFinalized.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            self.guardarEstadisticas()
            self.performSegue(withIdentifier:"doneSegue", sender: nil)
        }))
        
        present(alertFinalized, animated: true, completion: nil)
    }
    
    func guardarEstadisticas() {
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        let entEjercicios = NSEntityDescription.insertNewObject(forEntityName: "Ejercicios", into: managedContext) as! Ejercicios
        
        entEjercicios.aciertos = Int16(self.aciertos)
        entEjercicios.fallos = Int16(self.fallos)
        entEjercicios.fecha = NSDate()
        entEjercicios.tiempo = Int16(totalTime!)
        
        currentUser?.addToUsuarioEjercicios(entEjercicios)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No se pudo las estadisticas al usuario, error: \(error), \(error.userInfo)")
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz"
        
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func completarBotones(cuantos: Int) {
        var total = cuantos
        
        while total != 0 {
            let i = Int(arc4random_uniform(24))
            if botones[i].titleLabel?.text != selectedLetter {
                botones[i].setTitle(selectedLetter, for: .normal)
                total -= 1
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            let controller = (segue.destination as! ActivitiesViewController)
            controller.nameUser = userName?.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anchoBoton = (vista.layer.bounds.size.width - 320) / 6
        altoBoton = (vista.layer.bounds.size.height - 135) / 4
        
        selectedLetter = randomString(length: 1)
        
        crearBotones()
        
        if letraPuesta < 6 {
            completarBotones(cuantos: (6-letraPuesta))
        }
        
        vistaSec.layer.borderColor = (UIColor.black).cgColor
        vistaSec.layer.borderWidth = 1
        
        labelTouch.text = "TOUCH EVERY: \(selectedLetter!)"
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
