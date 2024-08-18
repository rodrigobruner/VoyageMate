//
//  AboutViewController.swift
//  VoyageMate
//
//  Created by Rodrigo Bruner on 2024-08-17.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func linkedin(_ sender: Any) {
        if let url = URL(string: "https://www.linkedin.com/in/rodrigobruner/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
