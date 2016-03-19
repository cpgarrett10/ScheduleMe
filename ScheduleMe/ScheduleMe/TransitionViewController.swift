//
//  tranViewController.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 3/19/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController{
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var FindAServiceLabel: UIButton!
    @IBOutlet weak var ProvideAServiceLabel: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gradientView.initGradient()
        
        
                FindAServiceLabel.backgroundColor = UIColor.clearColor()
                FindAServiceLabel.layer.cornerRadius = 5
                FindAServiceLabel.layer.borderWidth = 1
                FindAServiceLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        
                ProvideAServiceLabel.backgroundColor = UIColor.clearColor()
                ProvideAServiceLabel.layer.cornerRadius = 5
                ProvideAServiceLabel.layer.borderWidth = 1
                ProvideAServiceLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        
    }
    
    
}
