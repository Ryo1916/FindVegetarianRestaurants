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

    typealias APIParams = [String: Any]

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var searchField: ErrorTextField!
    @IBAction func searchByTextPressed(_ sender: UIButton) {
        let freeWords = searchField.text!
        getWeatherDataByFreeWords(url: GURUNAVI_API, freeWords: freeWords)
    }
    @IBAction func searchByLocationPressed(_ sender: UIButton) {
    }

    // TODO: Create options selection "english_speaking_staff" and "english_menu"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getWeatherDataByFreeWords(url: String, freeWords: String) {
        let paramsWithFreeWords: APIParams = ["keyid": API_KEY, "lang": "en", "freeword": freeWords, "english_speaking_staff": 0, "english_menu": 0, "vegetarian_menu_options": 1]
        var restaurants = [Restaurant]()
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)

        Alamofire.request(url, method: .get, parameters: paramsWithFreeWords).responseJSON(queue: queue) {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data by free words.")
                
                let responseJSON: JSON = JSON(response.result.value!)
                print(responseJSON)

                responseJSON["rest"].forEach { (_, json) in
                    let restaurant: Restaurant = Restaurant()
                    restaurant.name = json["name"]["name"].stringValue
                    restaurant.businessHour = json["business_hour"].stringValue
                    restaurant.categories = json["categories"]["category_name_s"].arrayValue.map {$0.stringValue}
                    restaurant.url = json["url"].stringValue
                    restaurant.imageURL = json["image_url"]["thumbnail"].stringValue
                    restaurants.append(restaurant)
                }
            } else {
                print("Error \(String(describing: response.result.error))")
                self.appName.text = "Connection Issues"
                self.appName.textColor = .red
            }
            semaphore.signal()
        }
        semaphore.wait()

        restaurants.forEach { restaurant in
            print(restaurant.name!)
            print(restaurant.businessHour!)
            print(restaurant.categories!)
            print(restaurant.url!)
            print(restaurant.imageURL!)
        }
    }
}
