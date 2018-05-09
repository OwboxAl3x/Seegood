//
//  TaskViewController.swift
//  Seegood
//
//  Created by Alejandro Garcia Vallecillo on 8/5/18.
//  Copyright © 2018 Alejandro Garcia Vallecillo. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var tablaEventos: UITableView!
    
    var userName: String?
    var currentUser: Usuarios?
    
    let todaysDate = Date()
    
    var events: [Evento] = Array()
    
    var selected: Date?
    
    let outsideMonthColor = UIColor.white
    let monthColor = UIColor(colorWithHexValue: 0x584a66)
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    
    let formatter = DateFormatter()
    
    @IBAction func addEvent(_ sender: Any) {
        
        newEvent()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaEventos.delegate = self
        tablaEventos.dataSource = self
        
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

        getEvents()
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        setupCalendarView()
        
    }
    
    func newEvent() {
        
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        let entEvent = NSEntityDescription.insertNewObject(forEntityName: "Evento", into: managedContext) as! Evento
        
        let alertNewEvent = UIAlertController(title: "New Event", message: "Enter the task", preferredStyle: .alert)
        
        alertNewEvent.addAction(UIAlertAction(title: "Add Event", style: .default, handler: {
            alert -> Void in
            let nombre = alertNewEvent.textFields![0] as UITextField
            
            if nombre.text != "" {
                
                entEvent.fecha = self.selected! as NSDate
                entEvent.nombreEvento = nombre.text!
                
                self.currentUser?.addToUsuarioEvento(entEvent)
                self.getEvents()
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("No se pudo las estadisticas al usuario, error: \(error), \(error.userInfo)")
                }
                
                self.tablaEventos.reloadData()
                
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Please input the name of the task", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertNewEvent, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        alertNewEvent.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action) in }))
        
        alertNewEvent.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Name"
            textField.textAlignment = .center
        })
        
        present(alertNewEvent, animated: true, completion: nil)
        
    }
    
    func setupCalendarView() {
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates { (visibleDates) in
            
            self.setupViewsOfCalendar(from: visibleDates)
            
        }
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
        
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CustomCell else { return }
        
        formatter.dateFormat = "dd MM yyyy"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        if todaysDateString == monthDateString {
            validCell.dateLabel.textColor = UIColor.red
        } else {
            
            if cellState.isSelected {
                validCell.dateLabel.textColor = selectedMonthColor
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = monthColor
                } else {
                    validCell.dateLabel.textColor = outsideMonthColor
                }
            }
            
        }
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
            selected = cellState.date
        } else {
            validCell.selectedView.isHidden = true
        }
        
    }
    
    func handleCellEvents(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CustomCell else { return }
        
        for i in 0..<events.count {
            
            if events[i].fecha == cellState.date as NSDate {
                validCell.dateLabel.textColor = UIColor.orange
            }
            
        }
        
    }
    
    func getEvents() {
        
        for i in 0..<(currentUser?.usuarioEvento?.count)! {
            
            let event = currentUser?.usuarioEvento?.object(at: i) as! Evento
            
            if !events.contains(event) {
                events.append(event)
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEvent", for: indexPath)
        
        cell.textLabel?.text = "\(formatter.string(from: events[indexPath.row].fecha! as Date)) --> \(events[indexPath.row].nombreEvento!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
            managedContext.delete(events[indexPath.row])
            events.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error al borrar el ejercicio: \(error), \(error.userInfo)")
            }
            tablaEventos.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

extension TaskViewController:  JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "dd MM yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "01 01 2018")
        let endDate = formatter.date(from: "31 12 2018")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        
        return parameters
        
    }
    
}

extension TaskViewController: JTAppleCalendarViewDelegate {
    
    // Mostrar la celda
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
        
        return cell
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
        
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        setupViewsOfCalendar(from: visibleDates)
        
    }
 
}

extension UIColor {
    
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
        
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        
        )
    }
    
}














