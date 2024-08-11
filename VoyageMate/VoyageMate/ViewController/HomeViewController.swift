//
//  HomeViewController.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//

import UIKit

class HomeViewController: UIViewController {


    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func didTapSearch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tripListVC = storyboard.instantiateViewController(withIdentifier: "TripList") as? TripViewController {
            tripListVC.searchBarText = searchTextField.text
            self.navigationController?.pushViewController(tripListVC, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
