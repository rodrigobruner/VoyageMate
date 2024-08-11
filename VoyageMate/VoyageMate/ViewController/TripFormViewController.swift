//
//  AddTripViewController.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//

import UIKit

class TripFormViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var destinationTextField: UITextField!
    
    let startDatePicker = UIDatePicker()
    @IBOutlet weak var startTextField: UITextField!
    
    let endDatePicker = UIDatePicker()
    @IBOutlet weak var endTextField: UITextField!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    //Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var trip:Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField?.becomeFirstResponder()
        createStartDatepicker()
        createEndDatepicker()
        notesTextView?.isScrollEnabled = true
        //TODO: Add placeholder on notes
        
        if let trip = trip {
            nameTextField?.text = trip.name
            destinationTextField?.text = trip.destination
            if let start = trip.start {
                startTextField?.text = DateFormatter.localizedString(from: start, dateStyle: .medium, timeStyle: .none)
            }
            if let end = trip.end {
                endTextField?.text = DateFormatter.localizedString(from: end, dateStyle: .medium, timeStyle: .none)
            }
            notesTextView?.text = trip.notes
        }
    }
    
    
    @IBAction func didTapSave(_ sender: Any) {
        
        if let name = nameTextField.text, name.isEmpty {
            let alert = UIAlertController(title: "Oops!", message: "The name field is mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            do{
                let name = nameTextField.text
                let destination = destinationTextField.text
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                
                var start:Date? = nil
                if var startStr = startTextField.text, !startStr.isEmpty {
                    start = dateFormatter.date(from: startStr)
                }
                
                var end:Date? = nil
                if var endStr = endTextField.text, !endStr.isEmpty {
                    end = dateFormatter.date(from: endStr)
                }
                
                if let start = start, let end = end, end < start {
                    let alert = UIAlertController(title: "Oops!", message: "The end date cannot be earlier than the start date.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                var notes = notesTextView.text
                //TODO: Add placeholder on notes
                if notes == "Notes" {
                    notes = ""
                }
                
                if trip == nil {
                    createTrip(name: name!, destination: destination, start: start, end: end, notes: notes)
                } else {
                    updateTrip(trip: trip!, name: name!, destination: destination, start: start, end: end, notes: notes)
                }
                
                goToTirpList()
            } catch {
                print("TRIP FORM ERROR:\(error)")
                let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't create your trips.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        func goToTirpList(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tripList = storyboard.instantiateViewController(withIdentifier: "TripList") as? TripViewController {
                navigationController?.pushViewController(tripList, animated: true)
            }
        }
    }
    
    // MARK: - Core Data ---
    func createTrip(name:String, destination:String? = nil, start:Date? = nil , end:Date? = nil, notes:String? = nil){
        let newTrip = Trip(context: context)
        newTrip.tripID = UUID()
        newTrip.name = name
        newTrip.destination = destination
        newTrip.start = start
        newTrip.end = end
        newTrip.notes = notes

        do {
            try context.save()
        }catch{
            print("TRIP CREATE ERROR:\(error)")
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't create your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateTrip(trip: Trip, name:String, destination:String? = nil, start:Date? = nil , end:Date? = nil, notes:String? = nil){
        trip.name = name
        trip.destination = destination
        trip.start = start
        trip.end = end
        trip.notes = notes
        
        do {
            try context.save()
        }catch{
            print("TRIP UPDATE ERROR:\(error)")
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't update your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Start Date Picker ---
    func createStartDatepicker() {
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.datePickerMode = .date
    
        startTextField?.inputView = startDatePicker
        startTextField?.inputAccessoryView = createStartDatepickerToolbar()
    }
        
    func createStartDatepickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Botão Cancelar
        let btnCancel = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPressedOnStartDatepickerToolbar))
        
        // Espaçamento flexível entre os botões
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Botão Concluído
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressedOnStartDatepickerToolbar))
        
        // Adiciona os botões à toolbar
        toolbar.setItems([btnCancel, flexibleSpace, btnDone], animated: true)
        
        return toolbar
    }
    
    @objc func cancelPressedOnStartDatepickerToolbar() {
        // Ação para o botão Cancelar
        self.view.endEditing(true) // Simplesmente fecha o teclado
    }
    
    @objc func donePressedOnStartDatepickerToolbar() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.startTextField.text = dateFormatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
    }
    
    //MARK: End Date Picker ---
    func createEndDatepicker() {
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.datePickerMode = .date
    
        endTextField?.inputView = endDatePicker
        endTextField?.inputAccessoryView = createEndDatepickerToolbar()
    }
        
    func createEndDatepickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Botão Cancelar
        let btnCancel = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPressedOnEndDatepickerToolbar))
        
        // Espaçamento flexível entre os botões
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Botão Concluído
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressedOnEndDatepickerToolbar))
        
        // Adiciona os botões à toolbar
        toolbar.setItems([btnCancel, flexibleSpace, btnDone], animated: true)
        
        return toolbar
    }
    
    @objc func cancelPressedOnEndDatepickerToolbar() {
        // Ação para o botão Cancelar
        self.view.endEditing(true) // Simplesmente fecha o teclado
    }
    
    @objc func donePressedOnEndDatepickerToolbar() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.endTextField.text = dateFormatter.string(from: endDatePicker.date)
        self.view.endEditing(true)
    }
}
