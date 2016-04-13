//
//  StationManager.swift
//  velib
//
//  Created by Corentin Fouré on 12/04/16.
//  Copyright © 2016 Corentin Fouré. All rights reserved.
//

import Foundation
import Alamofire
import MapKit


class StationManagerClass {
    var data = [Station]()
    
    func getNearestStationsWithBikesAvailable(lat : Double, lng : Double, nbBikes : Int) -> [Station]{
        var stations = [Station]()
        
        sortWithLocation(lat, lng: lng)
        
        for station in data {
            if (station.available_bikes >= nbBikes) {
                stations.append(station)
            }
        }
        return stations
    }
    
    func sortWithLocation(lat : Double, lng : Double) {
        let origin = CLLocation(latitude: lat, longitude: lng)
        data.sortInPlace({ (left: Station, right: Station) -> Bool in
            let leftDistance = CLLocation(latitude: left.lat, longitude: left.lng).distanceFromLocation(origin)
            let rightDistance = CLLocation(latitude: right.lat, longitude: right.lng).distanceFromLocation(origin)
            
            left.distanceToUser = leftDistance
            right.distanceToUser = rightDistance
            
            return leftDistance < rightDistance
        })
    }
    
    func read(contract : String, success : ([Station]?)->(), error : (AnyObject?) -> ()) {
        let url = apiUrl + "stations"
        
        Alamo.request(.GET, nocache: false, URLString: url, parameters: ["apiKey" : apiKey, "contract" : contract], success: {
            json in
            self.data = [Station]()
            if let list = json! as? [AnyObject] {
                for item in list {
                    if let i = item as? [String : AnyObject] {
                        if let station = Station.load(i) {
                            self.data.append(station)
                        }
                    }
                }
            }
            success(self.data)
            }, error: {
                json in
                error(json)
        })
    }
    
}

let StationManager = StationManagerClass()