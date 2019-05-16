//
//  ViewController.swift
//  FindVegetarianRestaurants
//
//  Created by Ryo Fujimoto on 2019/05/15.
//  Copyright © 2019 Ryo Fujimoto. All rights reserved.
//

import UIKit
import Material
import Alamofire
import SwiftyJSON
import Keys

class SearchViewController: UIViewController {
    
    // constants
    private let GURUNAVI_API = "https://api.gnavi.co.jp/ForeignRestSearchAPI/v3/"
    private let API_KEY = FindVegetarianRestaurantsKeys().gurunaviAPIKey
    

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var searchField: ErrorTextField!
    @IBAction func searchByTextPressed(_ sender: UIButton) {
    }
    @IBAction func searchByLocationPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
