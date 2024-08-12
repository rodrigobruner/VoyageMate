//
//  CostFormViewController.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//

import UIKit

class CostFormViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var valueTextField: UITextField!
    
    let datePicker = UIDatePicker()
    @IBOutlet weak var dateTextField: UITextField!
    
    //Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cost:Cost?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapSave(_ sender: Any) {
        
    }
    
    func goToCostList(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tripList = storyboard.instantiateViewController(withIdentifier: "CostList") as? TripViewController {
            navigationController?.pushViewController(tripList, animated: true)
        }
    }
    
    
    //MARK: Start Date Picker ---
    func createStartDatepicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
    
        dateTextField?.inputView = datePicker
        dateTextField?.inputAccessoryView = createDatepickerToolbar()
    }
        
    func createDatepickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Botão Cancelar
        let btnCancel = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPressedOnDatepickerToolbar))
        
        // Espaçamento flexível entre os botões
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Botão Concluído
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressedOnDatepickerToolbar))
        
        // Adiciona os botões à toolbar
        toolbar.setItems([btnCancel, flexibleSpace, btnDone], animated: true)
        
        return toolbar
    }
    
    @objc func cancelPressedOnDatepickerToolbar() {
        // Ação para o botão Cancelar
        self.view.endEditing(true) // Simplesmente fecha o teclado
    }
    
    @objc func donePressedOnDatepickerToolbar() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
}
