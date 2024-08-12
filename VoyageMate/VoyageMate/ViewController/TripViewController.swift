//
//  TripViewController.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//

import UIKit
import CoreData

class TripViewController: UIViewController {

    //Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Search bar
    let searchbar = UISearchBar()
    var searchBarText: String?
    
    //Table View
    let tableView = UITableView()
    
    private var models = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SearchBar
        searchbar.text = searchBarText
        searchbar.placeholder = "Search"
        searchbar.sizeToFit()
        searchbar.barTintColor = UIColor(named: "background")
        searchbar.delegate = self
        
        //TableView
        tableView.register(TripTableViewCell.self, forCellReuseIdentifier: "tripCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchbar
        tableView.backgroundColor = UIColor(named: "background")
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        getAllTrip()
        if let searchText = searchbar.text, !searchText.isEmpty {
            getTrips(by: searchbar.text!)
        }
    }
}

// MARK: SearchBar ---
extension TripViewController:UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            getAllTrip()
        } else {
//            print(searchText)
            getTrips(by: searchText)
        }
    }
}


// MARK: Table View ---
extension TripViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        cell.textLabel?.text = model.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instancie o UITabBarController a partir do storyboard
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabTripDetail") as? UITabBarController {
            
            // Configure as view controllers do tab bar
            if let viewControllers = tabBarController.viewControllers {
                for viewController in viewControllers {
                    if let tripDetailsVC = viewController as? TripDetailsViewController {
                        tripDetailsVC.trip = self.models[indexPath.row]
                    }
                }
            }
            
            // Navegue para o UITabBarController
            self.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteTrip(trip: self.models[indexPath.row])
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tripFormVC = storyboard.instantiateViewController(withIdentifier: "NewTrip") as? TripFormViewController {
                tripFormVC.trip = self.models[indexPath.row]
                self.navigationController?.pushViewController(tripFormVC, animated: true)
            }
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
}

// MARK: Core Data ---
extension TripViewController{
    
    func deleteTrip(trip: Trip){
//        print(trip)
        context.delete(trip)
        do {
            try context.save()
            getAllTrip()
        }catch{
            print("TRIP DELETE ERROR:\(error)")
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't delete your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getAllTrip(){
//        print("getAllTrip")
        do {
            models = try context.fetch(Trip.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            print("TRIP GET ALL ERROR:\(error)")
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't get your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getTrips(by name: String) {
//        print(name)
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
        
        do {
            models = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("TRIP GET BY NAME ERROR:\(error)")
            let alert = UIAlertController(title: "Oops! An unexpected error occurred", message: "We couldn't search your trips.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
