//
//  GradientView.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 3/12/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//


import UIKit

class GradientView: UIView {
    
    var location:CGFloat = 1.0
    var sr:CGFloat = 131
    var sg:CGFloat = 164
    var sb:CGFloat = 212
//    var sr:CGFloat = 100
//    var sg:CGFloat = 200
//    var sb:CGFloat = 255
    

    
    
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    func initGradient() {
        // define colors, insert into array
        
        //        let startColor = UIColor(red: 81/255, green: 127/255, blue: 164/255, alpha: 1)
        //        let endColor = UIColor(red: 36/255, green: 57/255, blue: 73/255, alpha: 1)
        let startColor = UIColor(red: self.sr/255, green: self.sg/255, blue: self.sb/255, alpha: 1)
        let endColor = UIColor(red: 182/255, green: 251/255, blue: 255/255, alpha: 1)
        let colors = [startColor.CGColor, endColor.CGColor]
        
        // set location for color transition
        // color1 is main color from 0 -> 0.6, then transition to color2
        let colorLocations: [CGFloat] = [0.0, self.location]
        
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
        
        print("initGradient is triggering")
        
        
        
        if self.sr < 255{
            
            print("Inside the loop")
            self.sr = self.sr + 1
            
            print("SR COUNT: " + String(sr))
            print("SG COUNT: " + String(sg))
            print("SB COUNT: " + String(sb))
            print("Location: " + String(location))
            self.initGradient()
        }
        
        
        if self.sg < 255{
            
            self.sg = self.sg + 1
            self.initGradient()
            }
        if self.sb < 255{
            
            self.sb = self.sb + 1
            self.initGradient()
            }
        
        if self.location > 0.25{
            
            self.location = self.location - 0.25
            self.initGradient()
        }
        
      
    }

}
