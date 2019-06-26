//
//  ResultsTableViewController.swift
//  FindVegetarianRestaurants
//
//  Created by Ryo Fujimoto on 2019/05/16.
//  Copyright © 2019 Ryo Fujimoto. All rights reserved.
//

import UIKit
import Material
import Alamofire
import SwiftyJSON
import Keys

class ResultsTableViewController: UITableViewController {
    
    // constants
    private let GURUNAVI_API = "https://api.gnavi.co.jp/ForeignRestSearchAPI/v3/"
    private let API_KEY = FindVegetarianRestaurantsKeys().gurunaviAPIKey
    var restaurants = [Restaurant]()
    var freeWords: String?
    
    typealias APIParams = [String: Any]

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let paramsWithFreeWords = setParamsByFreeWords(freeWords: freeWords!)
        restaurants = getRestaurantsData(url: GURUNAVI_API, params: paramsWithFreeWords)
    }
    
    func setParamsByFreeWords(freeWords: String) -> APIParams {
        let paramsWithFreeWords: APIParams = ["keyid": API_KEY, "lang": "en", "freeword": freeWords, "english_speaking_staff": 0, "english_menu": 0, "vegetarian_menu_options": 1]
        return paramsWithFreeWords
    }
    
    func getRestaurantsData(url: String, params: APIParams) -> [Restaurant] {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON(queue: queue) {
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
                    self.restaurants.append(restaurant)
                }
            } else {
                print("Error \(String(describing: response.result.error))")
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
        return restaurants
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(restaurants.count)
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath) as? ResultsTableViewCell else {
            fatalError("The dequeued cell is not an instance of ResultsTableViewCell.")
        }
        let restaurant = restaurants[indexPath.row]
        
        let url = URL(string: restaurant.imageURL!)
        do {
            let data = try Data(contentsOf: url!)
            cell.restaurantImageView.image = UIImage(data: data)
        } catch {
            print("Error : Cannot get the image from API server.")
        }
        cell.restaurantNameLabel.text = restaurant.name
        cell.businessHourLabel.text = restaurant.businessHour
        cell.categoriesLabel.text = restaurant.categories?.joined(separator: ",")
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
