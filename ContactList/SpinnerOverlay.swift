//
//  SpinnerOverlay.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/11/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

public class SpinnerOverlay {
    
    var overlayView : UIView!
    var activityIndicator : UIActivityIndicatorView!
    
    static let sharedInstance = SpinnerOverlay()
    
    init() {
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
        
        overlayView.frame = CGRectMake(0, 0, 80, 80)
        overlayView.backgroundColor = UIColor.lightGrayColor()
        overlayView.alpha = 0.4
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1
        
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        overlayView.addSubview(activityIndicator)
    }
    
    public func show(view: UIView) {
        overlayView.center = view.center
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }
    
    public func hide() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }

}
