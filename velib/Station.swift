//
//  Station.swift
//  velib
//
//  Created by Corentin Fouré on 12/04/16.
//  Copyright © 2016 Corentin Fouré. All rights reserved.
//

import Foundation

/*
 {
    "number": 123,
    "contract_name" : "Paris",
    "name": "stations name",
    "address": "address of the station",
    "position": {
        "lat": 48.862993,
        "lng": 2.344294
    },
    "banking": true,
    "bonus": false,
    "status": "OPEN",
    "bike_stands": 20,
    "available_bike_stands": 15,
    "available_bikes": 5,
    "last_update": <timestamp>
 }
*/


class Station: NSObject {
    var number = -1
    var contract_name = ""
    var name = ""
    var address = ""
    var lat = 0.0
    var lng = 0.0
    var banking = false
    var bonus = false
    var status = ""
    var bike_stands = 0
    var available_bike_stands = 0
    var available_bikes = 0
    var distanceToUser = -1.0 // METERS
    var last_update = NSDate()
    
    override var description: String {
        return "[Station] {number = \(number), contract_name = \(contract_name), name = \(name), address = \(address), lat = \(lat), lng = \(lng), banking = \(banking), bonus = \(bonus), status = \(status), bike_stands = \(bike_stands), available_bike_stands = \(available_bike_stands), available_bikes = \(available_bikes)}"
    }
    
    init(number : Int, contract_name : String, name : String, address : String, lat : Double, lng : Double, banking : Bool, bonus : Bool, status : String, bike_stands : Int, available_bike_stands : Int, available_bikes : Int, last_update : NSDate) {
        self.number = number
        self.contract_name = contract_name
        self.name = name
        self.address = address
        self.lat = lat
        self.lng = lng
        self.banking = banking
        self.bonus = bonus
        self.status = status
        self.bike_stands = bike_stands
        self.available_bike_stands = available_bike_stands
        self.available_bikes = available_bikes
        self.last_update = last_update
    }
 
    class func load(json : [String:AnyObject]) -> Station? {
        guard let number = json["number"] as? Int, let contract_name = json["contract_name"] as? String, let name = json["name"] as? String, let address = json["address"] as? String, let position = json["position"] as? [String:AnyObject], let lat = position["lat"] as? Double, let lng = position["lng"] as? Double, let banking = json["banking"] as? Bool, let bonus = json["bonus"] as? Bool, let status = json["status"] as? String, let bike_stands = json["bike_stands"] as? Int, let available_bike_stands = json["available_bike_stands"] as? Int, let available_bikes = json["available_bikes"] as? Int else {
            return nil
        }
        
        return Station(number: number, contract_name: contract_name, name: name, address: address, lat: lat, lng: lng, banking: banking, bonus: bonus, status: status, bike_stands: bike_stands, available_bike_stands: available_bike_stands, available_bikes: available_bikes, last_update: NSDate())
    }
    
    func isOpen() -> Bool {
        return self.status == "OPEN"
    }
    
}