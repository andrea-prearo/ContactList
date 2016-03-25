//
//  UIImageView+Util.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/9/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

extension UIImageView {

    func downloadImageFromUrl(url: String) {
        guard let url = NSURL(string: url)
        else {
            return
        }
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
            else {
                return
            }
            dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
                self?.image = image
                if let width = self?.frame.size.width {
                    self?.roundedImage(width * CGFloat(0.5))
                }
            }
        }).resume()
    }

    private func roundedImage(cornerRadius: CGFloat) {
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }

}
