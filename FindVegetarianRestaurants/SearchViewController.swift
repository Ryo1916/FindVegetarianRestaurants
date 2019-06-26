//
//  ViewController.swift
//  FindVegetarianRestaurants
//
//  Created by Ryo Fujimoto on 2019/05/15.
//  Copyright © 2019 Ryo Fujimoto. All rights reserved.
//

import UIKit
import Material

class SearchViewController: UIViewController {

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var searchField: ErrorTextField!
    @IBAction func searchByTextPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "searchByText", sender: nil)
    }
    @IBAction func searchByLocationPressed(_ sender: UIButton) {
    }

    // TODO: Create options selection "english_speaking_staff" and "english_menu"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! UINavigationController
        let resultsTableViewController = destinationVC.viewControllers[0] as! ResultsTableViewController
        if segue.identifier == "searchByText" {
            print(searchField.text!)
            resultsTableViewController.freeWords = searchField.text!
        }
    }
}
