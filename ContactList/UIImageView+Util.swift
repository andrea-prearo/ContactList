//
//  UIImageView+Util.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/9/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit

extension UIImageView {

    class func defaultAvatarImage() -> UIImage? {
        return UIImage(named: "Avatar")
    }

    func downloadImageFromUrl(url: String, defaultImage: UIImage? = UIImageView.defaultAvatarImage()) {
        guard let url = NSURL(string: url)
        else {
            setRoundedImage(defaultImage)
            return
        }
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
            else {
                self?.setRoundedImage(defaultImage)
                return
            }
            self?.setRoundedImage(image)
        }).resume()
    }

    private func setRoundedImage(image: UIImage?) {
        guard let image = image else {
            return
        }
        dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
            self?.image = image
            if let width = self?.frame.size.width {
                self?.roundedImage(width * CGFloat(0.5))
            }
        }
    }

    private func roundedImage(cornerRadius: CGFloat, withBorder: Bool = true) {
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        if withBorder {
            layer.borderColor = UIColor.whiteColor().CGColor
        }
        clipsToBounds = true
    }

}
