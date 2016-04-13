//
//  PointAnnotationStation.swift
//  velib
//
//  Created by Corentin Fouré on 12/04/16.
//  Copyright © 2016 Corentin Fouré. All rights reserved.
//

import Foundation
import MapKit

class PointAnnotationStation: MKPointAnnotation {
    var station : Station?
    
    override init() {
        super.init()
    }
}