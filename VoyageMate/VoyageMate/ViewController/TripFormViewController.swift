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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createStartDatepicker()
        createEndDatepicker()
        notesTextView.isScrollEnabled = true
    }
    
    
    @IBAction func didTapSave(_ sender: Any) {
        
    }
    
    //MARK: Start Date Picker ---
    func createStartDatepicker() {
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.datePickerMode = .date
    
        startTextField.inputView = startDatePicker
        startTextField.inputAccessoryView = createStartDatepickerToolbar()
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
    
        endTextField.inputView = endDatePicker
        endTextField.inputAccessoryView = createEndDatepickerToolbar()
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
