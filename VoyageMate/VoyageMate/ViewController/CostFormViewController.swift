import UIKit

class CostFormViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    let datePicker = UIDatePicker()
    @IBOutlet weak var dateTextField: UITextField!
    
    // Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var trip: Trip?
    var cost: Cost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        createStartDatepicker()
        
        if let cost = cost {
            nameTextField?.text = cost.name
            valueTextField?.text = String(format: "%.2f", cost.value)
            if let date = cost.date {
                dateTextField?.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            }
        }
    }
    
    @IBAction func didTapSave(_ sender: Any) {
//        print("SAVE")
        if let name = nameTextField.text, name.isEmpty {
            let alert = UIAlertController(title: "Oops!", message: "The name field is mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let value = valueTextField.text, value.isEmpty {
            let alert = UIAlertController(title: "Oops!", message: "The value field is mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let name = nameTextField.text
        let value = Double(valueTextField.text!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
       
        
        var date:Date? = nil
        if let dateStr = dateTextField.text, !dateStr.isEmpty {
            date = dateFormatter.date(from: dateStr)
        }
        
        print("SAVE DATA: \(String(describing: name)) - \(String(describing: value)) \(String(describing: date))")
        
        if cost == nil {
            createCost(name: name!, value: value!, date: date)
        } else {
           updateCost(cost: cost!, name: name!, value: value!, date: date)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("DidUpdateData"), object: nil)
        goToCostList()
    }
    
    func goToCostList() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Core Data ---
    func createCost(name: String, value: Double, date: Date? = nil) {
        
        print("CREATE DATA: \(name) - \(value) \(String(describing: date))")
        
        let newCost = Cost(context: context)
        newCost.createdAt = Date()
        newCost.name = name
        newCost.value = value
        newCost.date = date
        
        trip!.addToCosts(newCost)
        
        do {
            try context.save()
        } catch {
            print("TRIP CREATE ERROR: \(error)")
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't create your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateCost(cost: Cost, name: String, value: Double, date: Date? = nil) {
        
        print("UPDATE DATA: \(name) - \(value) \(String(describing: date))")
        
        cost.name = name
        cost.value = value
        cost.date = date
        
        do {
            try context.save()
        } catch {
            print("TRIP UPDATE ERROR: \(error)")
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't update your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Start Date Picker ---
    func createStartDatepicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createDatepickerToolbar()
    }
    
    func createDatepickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnCancel = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPressedOnDatepickerToolbar))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressedOnDatepickerToolbar))
        
        toolbar.setItems([btnCancel, flexibleSpace, btnDone], animated: true)
        return toolbar
    }
    
    @objc func cancelPressedOnDatepickerToolbar() {
        self.view.endEditing(true)
    }
    
    @objc func donePressedOnDatepickerToolbar() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
