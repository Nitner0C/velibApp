//
//  RootViewController.swift
//  velib
//
//  Created by Corentin Fouré on 12/04/16.
//  Copyright © 2016 Corentin Fouré. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol BikeSelectionPopinDelegate {
    func confirmedNumberOfBikes(bikeSelectionPopinViewController : BikeSelectionPopinViewController, nbBikes: Int)
}

protocol StationDetailsPopinDelegate {
    func moveMapToCoordinates(stationDetailsPopinViewController : StationDetailsPopinViewController, lat: Double, lng: Double)
    func isDismissing(stationDetailsPopinViewController : StationDetailsPopinViewController)
}



class RootViewController: UIViewController, MKMapViewDelegate, BikeSelectionPopinDelegate, StationDetailsPopinDelegate {
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation?
    var token : dispatch_once_t = 0
    var numberOfBikes = 1
    
    override func viewDidLoad() {
        initView()
        
        mapView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.locationUpdate(_:)), name: LocationUpdate, object: nil)
        StationManager.read("Paris", success: {
            stations in
            if let stations = stations{
                for station in stations {
                    let stationAnnotation = PointAnnotationStation()
                    let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
                        latitude: station.lat,
                        longitude: station.lng)
                    
                    stationAnnotation.coordinate = coordinate
                    stationAnnotation.station = station
                    self.mapView.addAnnotation(stationAnnotation)
                }
            }
            self.bottomButton.userInteractionEnabled = true
            }, error: {
                error in
                print("DAMMIT! \(error)")
        })
    }
    
    func initView() {
        bottomButton.layer.cornerRadius = bottomButton.bounds.height / 2
        bottomButton.layer.borderWidth = 0.5
        bottomButton.layer.borderColor = UIColor.blackColor().CGColor
        bottomButton.clipsToBounds = true
        bottomButton.userInteractionEnabled = false
    }
    
    @IBAction func bottomButtonTouch(sender: AnyObject) {
        performSegueWithIdentifier(selectBikeNumberSegue, sender: nil)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        guard let point = view.annotation as? PointAnnotationStation, let station = point.station else {
            return
        }
        performSegueWithIdentifier(infosStationSegue, sender: station)
    }
    
    func locationUpdate(notification: NSNotification){
        self.location = (UIApplication.sharedApplication().delegate as! AppDelegate).userLocation
        dispatch_once(&token) {
            let span = MKCoordinateSpanMake(0.003, 0.003)
            let centerLat = self.location?.coordinate.latitude
            let centerLng = self.location?.coordinate.longitude
            let loc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: centerLat!, longitude: centerLng!)
            let region = MKCoordinateRegion(center: loc, span: span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == selectBikeNumberSegue) {
            if let dest = segue.destinationViewController as? BikeSelectionPopinViewController {
                dest.delegate = self
            }
        } else if (segue.identifier == infosStationSegue) {
            if let dest = segue.destinationViewController as? StationDetailsPopinViewController {
                bottomButton.hidden = true
                dest.station = sender as? Station
                dest.stationList = sender as? [Station]
                dest.delegate = self
            }
        }
        
    }
    
    // Custom Delegates
    
    func confirmedNumberOfBikes(bikeSelectionPopinViewController : BikeSelectionPopinViewController, nbBikes: Int) {
        if let loc = location {
            let stations = StationManager.getNearestStationsWithBikesAvailable(loc.coordinate.latitude, lng: loc.coordinate.longitude, nbBikes: nbBikes)
            performSegueWithIdentifier(infosStationSegue, sender: stations.count == 0 ? nil : stations)
        }
    }
    
    func moveMapToCoordinates(stationDetailsPopinViewController : StationDetailsPopinViewController, lat: Double, lng: Double) {
        let span = MKCoordinateSpanMake(0.006, 0.006)
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: loc, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func isDismissing(stationDetailsPopinViewController : StationDetailsPopinViewController) {
        bottomButton.hidden = false
    }
    
    
}