//
//  Contract.swift
//  velib
//
//  Created by Corentin Fouré on 12/04/16.
//  Copyright © 2016 Corentin Fouré. All rights reserved.
//

import Foundation


class Contract : NSObject {
    var name = ""
    var commercial_name = ""
    var country_code = ""
    var cities : [String] = []
    
    override var description: String {
        return "Contract : { name = \(name), commercial_name = \(commercial_name), country_code = \(country_code), cities = \(cities)"
    }
    
    init(name : String, commercial_name : String, country_code : String, cities : [String]) {
        self.name = name
        self.commercial_name = commercial_name
        self.country_code = country_code
        self.cities = cities
    }
    
    class func load(json : [String:AnyObject]) -> Contract? {
        guard let name = json["name"] as? String, let commercial_name = json["commercial_name"] as? String, let country_code = json["country_code"] as? String, let cities = json["cities"] as? [String] else {
            return nil
        }
        return Contract(name: name, commercial_name: commercial_name, country_code: country_code, cities: cities)
    }
}