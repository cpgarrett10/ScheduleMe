//
//  TransitionViewController.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 3/19/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit

class TransitionViewController : UIViewController {

    
    
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var findAServiceLabel: UIButton!
    @IBOutlet weak var provideAServiceLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gradientView.initGradient()
        
        findAServiceLabel.backgroundColor = UIColor.clearColor()
        findAServiceLabel.layer.cornerRadius = 5
        findAServiceLabel.layer.borderWidth = 1
        findAServiceLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        provideAServiceLabel.backgroundColor = UIColor.clearColor()
        provideAServiceLabel.layer.cornerRadius = 5
        provideAServiceLabel.layer.borderWidth = 1
        provideAServiceLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    
}
