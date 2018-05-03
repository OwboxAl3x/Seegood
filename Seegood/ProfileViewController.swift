//
//  ProfileViewController.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 1/5/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//

import UIKit
import CoreData
import Photos
import Charts

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var phoneUser: UITextField!
    @IBOutlet weak var addressUser: UITextField!
    @IBOutlet weak var birthdayUser: UIDatePicker!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var noImagen: UILabel!
    
    @IBOutlet weak var CCODlabel: UITextField!
    @IBOutlet weak var CCOIlabel: UITextField!
    @IBOutlet weak var SCODlabel: UITextField!
    @IBOutlet weak var SCOIlabel: UITextField!
    
    @IBOutlet weak var chtChart: LineChartView!
    @IBOutlet weak var actuChart: UITextField!
    
    var userName: String?
    var currentUser: Usuarios?
    
    var camaraPermisos: Bool = false
    var libreriaPermisos: Bool = false

    @IBAction func updateAV(_ sender: Any) {
        
        if (currentUser?.usuarioAV?.count)! < 1 {
            
            let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
            let av = NSEntityDescription.insertNewObject(forEntityName: "AgudezaVisual", into: managedContext) as! AgudezaVisual
            
            if CCODlabel.text != nil {
                av.ccOjoDer = (CCODlabel.text! as NSString).floatValue
            } else {
                av.ccOjoDer = 0.0
            }
            if CCODlabel.text != nil {
                av.ccOjoIzq = (CCOIlabel.text! as NSString).floatValue
            } else {
                av.ccOjoIzq = 0.0
            }
            if CCODlabel.text != nil {
                av.scOjoDer = (SCODlabel.text! as NSString).floatValue
            } else {
                av.scOjoDer = 0.0
            }
            if CCODlabel.text != nil {
                av.scOjoIzq = (SCOIlabel.text! as NSString).floatValue
            } else {
                av.scOjoIzq = 0.0
            }
            
            CCODlabel.text = ""
            CCOIlabel.text = ""
            SCODlabel.text = ""
            SCOIlabel.text = ""
            
            CCODlabel.endEditing(true)
            CCOIlabel.endEditing(true)
            SCODlabel.endEditing(true)
            SCOIlabel.endEditing(true)
            
            av.fecha = Date() as NSDate
            
            currentUser?.addToUsuarioAV(av)
            
            do {
                try managedContext.save()
                updateGraph()
            } catch let error as NSError {
                print("No se pudo las estadisticas al usuario, error: \(error), \(error.userInfo)")
            }
            
        } else {
            
            CCODlabel.endEditing(true)
            CCOIlabel.endEditing(true)
            SCODlabel.endEditing(true)
            SCOIlabel.endEditing(true)
            
            let alertVC = UIAlertController(title: "Message", message: "First AV already entered", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func actualizarChart(_ sender: Any) {
        
        if actuChart.text != "" {
        
            let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
            let av = NSEntityDescription.insertNewObject(forEntityName: "AgudezaVisual", into: managedContext) as! AgudezaVisual
        
            if (currentUser?.usuarioAV?.count)! > 0 {
                
                let ultimoAV = currentUser?.usuarioAV?.object(at: (currentUser?.usuarioAV?.count)!-1) as! AgudezaVisual
                
                let input = Float(actuChart.text!)
                
                if av.ccOjoDer < av.ccOjoIzq {
                    av.ccOjoDer = input!
                    av.ccOjoIzq = ultimoAV.ccOjoIzq
                    av.scOjoDer = ultimoAV.scOjoDer
                    av.scOjoIzq = ultimoAV.scOjoIzq
                    av.fecha = Date() as NSDate
                } else {
                    av.ccOjoIzq = input!
                    av.ccOjoDer = ultimoAV.ccOjoDer
                    av.scOjoDer = ultimoAV.scOjoDer
                    av.scOjoIzq = ultimoAV.scOjoIzq
                    av.fecha = Date() as NSDate
                }
                
                currentUser?.addToUsuarioAV(av)
                
                actuChart.text = ""
                actuChart.endEditing(true)
                
                do {
                    try managedContext.save()
                    updateGraph()
                } catch let error as NSError {
                    print("No se pudo las estadisticas al usuario, error: \(error), \(error.userInfo)")
                }
                
            } else {
                
                let alertVC = UIAlertController(title: "Message", message: "Enter a data before updating", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVC.addAction(action)
                present(alertVC, animated: true, completion: nil)
                
            }
        
        } else {
            
            let alertVC = UIAlertController(title: "Message", message: "Enter a data before updating", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    func updateGraph() {
        
        if (currentUser?.usuarioAV?.count)! > 0 {
        
            var lineChartEntry = [ChartDataEntry]()
            var ojo: String?
            
            for i in 0..<(currentUser?.usuarioAV?.count)! {
                
                let av = currentUser?.usuarioAV?.object(at: i) as! AgudezaVisual
                let dato: Double?
                if av.ccOjoDer < av.ccOjoIzq {
                    dato = Double(av.ccOjoDer)
                    ojo = "Con compensación Ojo Derecho"
                } else {
                    dato = Double(av.ccOjoIzq)
                    ojo = "Con compensación Ojo Izquierdo"
                }
                
                let value = ChartDataEntry(x: Double(i), y: dato!)
                lineChartEntry.append(value)
                
            }
            
            let line1 = LineChartDataSet(values: lineChartEntry, label: ojo)
            line1.colors = [UIColor.blue]
            
            let data = LineChartData()
            data.addDataSet(line1)
            
            chtChart.data = data
            chtChart.chartDescription?.text = "Agudeza Visual"
            
        }
        
    }
    
    @IBAction func updateData(_ sender: Any) {
        
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        
        if currentUser?.direccion != addressUser.text {
            currentUser?.direccion = addressUser.text
        }
        if currentUser?.telefono != phoneUser.text {
            currentUser?.telefono = phoneUser.text
        }
        if currentUser?.cumple != birthdayUser.date as NSDate {
            currentUser?.cumple = birthdayUser.date as NSDate
        }
        if photoUser.image != nil {
            let datosFoto = UIImageJPEGRepresentation(photoUser.image!, 0.5)
            currentUser?.foto = NSData(data: datosFoto!)
        }
        
        do {
            try managedContext.save()
            
            let alertVC = UIAlertController(title: "Message", message: "Data saved", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            present(alertVC, animated: true, completion: nil)
            
        } catch let error as NSError {
            print("No se pudo añadir el nuevo usuario, error: \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func camaraButton(_ sender: Any) {
        
        if camaraPermisos {
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                imagePicker.cameraCaptureMode = .photo
                self.present(imagePicker, animated: true, completion: nil)
                
            } else {
                
                print("No se pudo obtener acceso a la camara")
                
            }
            
        } else {
            
            let alertVC = UIAlertController(title: "Message", message: "We do not have permission to access the roll", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func carreteButton(_ sender: Any) {
        
        if libreriaPermisos {
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                
            } else {
                
                print("No se pudo obtener acceso a la libreria de fotos")
                
            }
            
        } else {
        
            let alertVC = UIAlertController(title: "Message", message: "We do not have permission to access the roll", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(action)
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        let userFecth: NSFetchRequest<Usuarios> = Usuarios.fetchRequest()
        userFecth.predicate = NSPredicate(format: "%K == %@", #keyPath(Usuarios.nombre), self.userName!)
        
        do {
            let resultado = try managedContext.fetch(userFecth)
            
            if resultado.count > 0 {
                currentUser = resultado.first
                nameUser.text = currentUser?.nombre
                addressUser.text = currentUser?.direccion
                phoneUser.text = currentUser?.telefono
                if currentUser?.cumple == nil {
                    birthdayUser.setDate(Date(), animated: true)
                } else {
                    birthdayUser.setDate((currentUser?.cumple as Date?)!, animated: true)
                }
                if currentUser?.foto != nil {
                    photoUser.image = UIImage(data: (currentUser?.foto as Data?)!)
                    noImagen.isHidden = true
                }
                
            }
        } catch let error as NSError {
            print("El error fue: \(error), \(error.userInfo)")
        }
        
        updateGraph()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestPermissions()
        
    }
    
    func requestPermissions() {
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
            self.camaraPermisos = granted
        }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case.authorized:
                self.libreriaPermisos = true
            default:
                self.libreriaPermisos = false
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.photoUser.image = pickedImage
            self.noImagen.isHidden = true
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }

}















