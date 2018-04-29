//
//  TestViewController.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 27/4/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet var vista: UIView!
    @IBOutlet weak var vistaSec: UIView!
    @IBOutlet weak var labelTouch: UILabel!
    @IBOutlet weak var labelAciertos: UILabel!
    @IBOutlet weak var labelFallos: UILabel!
    
    @IBAction func doneButton(_ sender: UIButton) {
        terminado()
    }
    
    var userName: String?
    
    var anchoBoton: CGFloat?
    var altoBoton: CGFloat?
    var botones: [UIButton] = Array()
    var selectedLetter: String?
    var letraPuesta:Int = 0
    var aciertos: Int = 0
    var fallos: Int = 0
    var aciertosTotales: Int = 10
    
    var primeraPulsación: Bool = true
    
    var startTime: CFTimeInterval?
    var endTime: CFTimeInterval?
    var totalTime: CFTimeInterval?
    
    func crearBotones() {
        
        var buttonX: CGFloat = 0
        var buttonY: CGFloat = 135
        for _ in 0...5 {
            for _ in 0...7 {
                
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
            self.performSegue(withIdentifier:"doneSegue", sender: nil)
        }))
        
        present(alertFinalized, animated: true, completion: nil)
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
            let i = Int(arc4random_uniform(40))
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
        // Do any additional setup after loading the view.
        anchoBoton = (vista.layer.bounds.size.width - 320) / 8
        altoBoton = (vista.layer.bounds.size.height - 135) / 6
        
        selectedLetter = randomString(length: 1)
        
        crearBotones()
        
        if letraPuesta < 10 {
            completarBotones(cuantos: (10-letraPuesta))
        }
        
        vistaSec.layer.borderColor = (UIColor.black).cgColor
        vistaSec.layer.borderWidth = 1
        
        labelTouch.text = "TOUCH EVERY: \(selectedLetter!)"
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
