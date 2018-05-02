//
//  ActivitiesViewController.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 23/4/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var tituloView: UINavigationItem!
    @IBOutlet weak var tests: UIButton!
    @IBOutlet weak var exercises: UIButton!
    @IBOutlet weak var tasks: UIButton!
    @IBOutlet weak var statistics: UIButton!
    @IBOutlet weak var profile: UIButton!
    
    var nameUser: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if nameUser != nil {
            if let detalle = detailDescriptionLabel {
                detalle.isHidden = true
                personalizarButtons()
            }
        }
    }
    
    func personalizarButtons () {
        ocultarYRedondear(boton: tests)
        ocultarYRedondear(boton: tasks)
        ocultarYRedondear(boton: exercises)
        ocultarYRedondear(boton: statistics)
        ocultarYRedondear(boton: profile)
        profile.setTitle(nameUser?.description.uppercased(), for: .normal)
    }
    
    func ocultarYRedondear(boton: UIButton) {
        if boton.isHidden == false {
            boton.isHidden = true
        } else {
            boton.isHidden = false
            boton.layer.cornerRadius = 5
            boton.layer.borderWidth = 4
            boton.layer.borderColor = (UIColor.orange).cgColor
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "testSegue" {
            let controller = (segue.destination as! TestViewController)
            controller.userName = nameUser?.description
        } else if segue.identifier == "exercisesSegue" {
            let controller = (segue.destination as! ExercisesViewController)
            controller.userName = nameUser?.description
        } else if segue.identifier == "estadisticasSegue" {
            let controller = (segue.destination as! EstadisticasViewController)
            controller.userName = nameUser?.description
        } else if segue.identifier == "profileSegue" {
            let controller = (segue.destination as! ProfileViewController)
            controller.userName = nameUser?.description
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

