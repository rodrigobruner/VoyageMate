//
//  CostViewController.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//

import UIKit
import CoreData

class CostViewController: UIViewController {
    
    //Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var totalCostLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var models = [Cost]()
    
    var trip: Trip?
    
    var totalCost:Double = 0.0

    @IBOutlet weak var statusView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let tabBar = tabBarController as! TabBarViewController
        trip = tabBar.objTrip
        
        //Table View
        tableView.dataSource = self
        tableView.delegate = self
        
        //Notification to update when a new cost is entered
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddCost), name: NSNotification.Name("DidUpdateData"), object: nil)
    }
    
    
    //Notification to update when a new cost is entered
    @objc func handleAddCost() {
        self.totalCost = 0.0
        getAllCost()
    }
    
    //MARK: Get trip --
    override func viewWillAppear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarViewController
        trip = tabBar.objTrip
        getAllCost()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarViewController
        tabBar.objTrip = trip
    }

    //MARK: Add new Cost --
    
    
    @IBAction func firstCost(_ sender: Any) {
        goToForm()
    }
    
    @IBAction func didTabAddCost(_ sender: Any) {
        goToForm()
    }
    
    func goToForm(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let newCostVC = storyboard.instantiateViewController(withIdentifier: "NewCost") as? CostFormViewController {
            newCostVC.trip = trip
            self.navigationController?.pushViewController(newCostVC, animated: true)
        }
    }
}



// MARK: Table View ---
extension CostViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "costCell", for: indexPath) as! CostTableViewCell
        
        self.totalCost += model.value
        cell.set(cost:model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let newCostVC = storyboard.instantiateViewController(withIdentifier: "NewCost") as? CostFormViewController {
            newCostVC.cost = models[indexPath.row]
            newCostVC.trip = trip
            self.navigationController?.pushViewController(newCostVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteCost(cost: self.models[indexPath.row])
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let newCostVC = storyboard.instantiateViewController(withIdentifier: "NewCost") as? CostFormViewController {
                newCostVC.cost = self.models[indexPath.row]
                self.navigationController?.pushViewController(newCostVC, animated: true)
            }
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 60.0
    }
}

// MARK: Core Data ---
extension CostViewController{
    
    func deleteCost(cost: Cost){
//        print(trip)
        context.delete(cost)
        do {
            try context.save()
            getAllCost()
        }catch{
            print("TRIP DELETE ERROR:\(error)")
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't delete your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getAllCost(){
        print("getAllTrip")

        guard let trip = trip else {
            print("No trip available")
            return
        }
        
        if let costsSet = trip.costs as? Set<Cost> {
            models = Array(costsSet)
            
            let formatterCurrency = NumberFormatter()
            formatterCurrency.numberStyle = .currency
            formatterCurrency.locale = Locale.current
            
            totalCost = models.reduce(0) { $0 + $1.value }
//            print(totalCost)
            let totalCostFormated = formatterCurrency.string(from: NSNumber(value: totalCost))
            
            totalCostLabel.text = "\(Constants.Cost.totalCost)\(totalCostFormated ?? "$0.00")"
            
            if totalCost > 0 {
                statusView.isHidden = true
            }
           
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            print("No costs found for the trip")
        }

    }
}
