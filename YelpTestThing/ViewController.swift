//
//  ViewController.swift
//  YelpTestThing
//
//  Created by Siraj Zaneer on 11/19/16.
//  Copyright © 2016 Siraj Zaneer. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {
    
    var token: String? = nil //Stores apps temporary "token" to tell server that yeah this device has permission to use the api

    let baseUrl = "https://api.yelp.com/oauth2/token" //Url for getting access
    let grant_type = "client_credentials" //A paramter that tells the server we want access for "client"
    let client_id = "518053Hp9nttpTmK1rW-ig" //App specific information so server know who is requesting and for what
    let client_secret = "XPB9eyCOwsvoVSfeVteaEZ0VwkTDMAyJvZ7b3LW3iy8JJk2XOx1bp7SyCqhpfCTZ" //Pretty much same as previous
    
    
    let searchURL = "https://api.yelp.com/v3/businesses/search" //Url for searching for things
    let location = "SanFrancisco,CA" //Some location
    
    var businesses: [JSON]? = nil //Where we are going to store all of our businesses
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /*
        This part looks like a lot of code but really what the first parameter is is just the url, the second is the method which type of request we are making which is a "POST" request which tells the server that we are sending information (clien id and secret) rather than asking for some, the third is parameters which are the information we are sending the server, the fourth is encoding which is the format in which we are sending the information, and then headers are nil because we don't have any. Then once we send the request the server sends back some information which we store in "response".
         */
        Alamofire.request(baseUrl, method: .post, parameters: ["grant_type" : grant_type, "client_id" : client_id, "client_secret" : client_secret], encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            
            // This part does different things based on whether or not it was successfull
            switch response.result.isSuccess {
                case true:
                if let value = response.result.value {
                    let info = JSON(value) //Since it was successful we store it in a JSON object
                    
                    self.token = info["access_token"].stringValue //Store it into the token variable so we can use it later on to tell the server we already have access to it!
                    
                    self.findBusinesses() // We call the search here to make sure we have
                }
                case false:
                print(response.result.error?.localizedDescription ?? "error")
            }
            
        }
        
        
        
        
    
    }
    
    func findBusinesses() {
        
        /*
         By now I think you kinda get the gist of how the request works but the one major difference here is that we now have parameters in the header which in  our case is the token! This tells Yelp that we have been granted access and the token is our password to get into the Yelp club :D!
         */
        Alamofire.request(searchURL, method: .get, parameters: ["location" : location], encoding: URLEncoding.default, headers: ["Authorization" : "Bearer \(token!)"]).validate().responseJSON { response in
            // This part does different things based on whether or not it was successfull
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    let info = JSON(value) //Since it was successful we store it in a JSON object
                    
                    self.businesses = info["businesses"].arrayValue //Store the businesses
                    
                    self.exampleBusinessAccess()
                    
                    
                }
            case false:
                print(response.result.error?.localizedDescription ?? "error")
            }
            
        }
    }
    
    /*
 {
 "id" : "the-temporarium-coffee-and-tea-san-francisco",
 "rating" : 5,
 "is_closed" : false,
 "review_count" : 114,
 "phone" : "+14155470616",
 "categories" : [
 {
 "title" : "Coffee & Tea",
 "alias" : "coffee"
 }
 ],
 "image_url" : "https:\/\/s3-media2.fl.yelpcdn.com\/bphoto\/mqP4uGnER6-6g9l9L9QBWA\/o.jpg",
 "url" : "https:\/\/www.yelp.com\/biz\/the-temporarium-coffee-and-tea-san-francisco?adjust_creative=518053Hp9nttpTmK1rW-ig&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=518053Hp9nttpTmK1rW-ig",
 "price" : "$",
 "location" : {
 "city" : "San Francisco",
 "country" : "US",
 "address1" : "3414 22nd St",
 "zip_code" : "94111",
 "address3" : "",
 "state" : "CA",
 "address2" : ""
 },
 "coordinates" : {
 "longitude" : -122.4235786,
 "latitude" : 37.7552528
 },
 "distance" : 1412.2572302276,
 "name" : "The Temporarium Coffee & Tea"
 }
 
 */
    
    /* 
    Each business will be in a json format like the above. Try using the online json reader to make it more easily readable!
    */
    
    //This function just prints out a few business names to show you how to access the information of each one!
    func exampleBusinessAccess() {
        
        print(businesses?[0]["name"] ?? "")
        print(businesses?[1]["name"] ?? "")
        print(businesses?[2]["name"] ?? "")
        print(businesses?[3]["name"] ?? "")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

