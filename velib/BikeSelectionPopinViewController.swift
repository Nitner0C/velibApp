//
//  BikeSelectionPopinViewController.swift
//  velib
//
//  Created by Corentin Fouré on 13/04/16.
//  Copyright © 2016 Corentin Fouré. All rights reserved.
//

import Foundation
import UIKit

class BikeSelectionPopinViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var nbBikesSelectedLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var delegate : BikeSelectionPopinDelegate?
    
    var nbBikes = 1
    
    override func viewDidLoad() {
        confirmButton.layer.borderColor = UIColor.blackColor().CGColor
        confirmButton.layer.borderWidth = 0.5
        
        increaseButton.layer.borderColor = UIColor.blackColor().CGColor
        increaseButton.layer.borderWidth = 0.5
        
        decreaseButton.layer.borderColor = UIColor.blackColor().CGColor
        decreaseButton.layer.borderWidth = 0.5
        
        nbBikesSelectedLabel.layer.borderColor = UIColor.blackColor().CGColor
        nbBikesSelectedLabel.layer.borderWidth = 0.5
        
        containerView.layer.borderColor = UIColor.blackColor().CGColor
        containerView.layer.borderWidth = 0.5
        
        nbBikesSelectedLabel.text = "\(nbBikes)"
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func exitButtonTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirmButtonTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.confirmedNumberOfBikes(self, nbBikes: nbBikes)
    }
    
    @IBAction func decreaseButtonTouchUp(sender: AnyObject) {
        if (nbBikes > minBikes) {
            nbBikes -= 1
        }
        nbBikesSelectedLabel.text = "\(nbBikes)"
    }
    
    @IBAction func increaseButtonTouchUp(sender: AnyObject) {
        if (nbBikes < maxBikes) {
            nbBikes += 1
        }
        nbBikesSelectedLabel.text = "\(nbBikes)"
    }
}