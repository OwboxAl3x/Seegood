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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var addressUser: UITextField!
    @IBOutlet weak var phoneUser: UITextField!
    @IBOutlet weak var birthdayUser: UIDatePicker!
    @IBOutlet weak var photoUser: UIImageView!
    
    var userName: String?
    var currentUser: Usuarios?
    
    var camaraPermisos: Bool = false
    var libreriaPermisos: Bool = false

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
                }
                
            }
        } catch let error as NSError {
            print("El error fue: \(error), \(error.userInfo)")
        }
        
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
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }

}















