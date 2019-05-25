//
//  Extensions.swift
//  iuvo
//
//  Created by boqian cheng on 2018-01-14.
//  Copyright © 2018 vpicku. All rights reserved.
//

import Foundation

extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect, startColor: UIColor, endColor: UIColor) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [startColor.cgColor, endColor.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        return layer
    }
    
    class func imageLayerForGradientBackground(naviBounds: CGRect, startColor: UIColor, endColor: UIColor) -> UIImage? {
        
        var updatedFrame = naviBounds
        // take into account the status bar
        updatedFrame.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(bounds: updatedFrame, startColor: startColor, endColor: endColor)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView{
    
    func addConstraintsWithFormat(format: String, views: UIView...){
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UITextField{
    
    func setPlaceHolderColor(){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
}
