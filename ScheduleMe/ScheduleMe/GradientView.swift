//
//  GradientView.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 3/12/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//


import UIKit

class GradientView: UIView {
    
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    func initGradient() {
        // define colors, insert into array
        
        //        let startColor = UIColor(red: 81/255, green: 127/255, blue: 164/255, alpha: 1)
        //        let endColor = UIColor(red: 36/255, green: 57/255, blue: 73/255, alpha: 1)
        let startColor = UIColor(red: 131/255, green: 164/255, blue: 212/255, alpha: 1)
        let endColor = UIColor(red: 182/255, green: 251/255, blue: 255/255, alpha: 1)
        let colors = [startColor.CGColor, endColor.CGColor]
        
        // set location for color transition
        // color1 is main color from 0 -> 0.6, then transition to color2
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // build gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = colorLocations
        
        // set the size of the gradient to bounds of the view
        gradientLayer.frame = self.bounds
        
        // start at the upper-left corner
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        // end at the bottom-right corner
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    
}