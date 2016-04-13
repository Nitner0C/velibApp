//
//  ContractManager.swift
//  velib
//
//  Created by Corentin Fouré on 12/04/16.
//  Copyright © 2016 Corentin Fouré. All rights reserved.
//

import Foundation
import Alamofire

class ContractManagerClass {
    var data = [Contract]()
    
    func getContracts() -> [Contract] {
        return data
    }
    
    func read() {
        let url = apiUrl + "contracts"
        
        Alamo.request(.GET, nocache: false, URLString: url, parameters: ["apiKey": apiKey], success: {
            json in
            if let list = json! as? [AnyObject] {
                for item in list {
                    if let i = item as? [String : AnyObject] {
                        if let contract = Contract.load(i) {
                            self.data.append(contract)
                        }
                    }
                }
            }
            }, error: {
                json in
                print(json)
        })
    }
}

let ContractManager = ContractManagerClass()