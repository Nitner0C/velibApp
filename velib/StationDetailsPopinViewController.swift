//
//  StationDetailsPopinViewController.swift
//  velib
//
//  Created by Corentin Fouré on 13/04/16.
//  Copyright © 2016 Corentin Fouré. All rights reserved.
//

import Foundation
import UIKit


class StationDetailsPopinViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bikeNumberLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var delegate : StationDetailsPopinDelegate?
    
    var station : Station?
    
    var stationList : [Station]?
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let stationList = stationList {
            station = stationList.first
            nextButton.hidden = false
        } else {
            nextButton.hidden = true
        }
        
        titleLabel.layer.borderWidth = 0.5
        titleLabel.layer.borderColor = UIColor.blackColor().CGColor
        
        bikeNumberLabel.layer.borderWidth = 0.5
        bikeNumberLabel.layer.borderColor = UIColor.blackColor().CGColor
        
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.blackColor().CGColor
        
        nextButton.layer.cornerRadius = nextButton.bounds.height / 2
        nextButton.layer.borderWidth = 0.5
        nextButton.layer.borderColor = UIColor.blackColor().CGColor
        nextButton.clipsToBounds = true

        
        fillData(station)
    }
    
    func fillData(station : Station?) {
        if let station = station {
            if (station.distanceToUser != -1.0) {
                titleLabel.text = "Infos Station (\(Int(station.distanceToUser))m)"
            } else {
                titleLabel.text = "Infos Station"
            }
            bikeNumberLabel.text = "\(station.bike_stands) stands à vélo (\(station.available_bikes) dispo)"
            collectionView.reloadData()
            delegate?.moveMapToCoordinates(self, lat: station.lat, lng: station.lng)
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let station = station {
            return station.bike_stands
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath)
        if let image : UIImageView = cell.contentView.subviews[0] as? UIImageView {
            if let station = station {
                image.image = UIImage(named: (indexPath.row < station.available_bikes ? "bike_green" : "bike_red"))
            }
        }
        return cell
    }
    
    @IBAction func goToNextStation(sender: AnyObject) {
        stationList?.removeFirst()
        station = stationList?.first
        
        if let station = station {
            fillData(station)
        } else {
            delegate?.isDismissing(self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func exitButtonTouchUp(sender: AnyObject) {
        delegate?.isDismissing(self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}