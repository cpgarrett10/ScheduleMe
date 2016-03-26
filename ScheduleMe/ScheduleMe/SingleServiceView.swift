//
//  SingleServiceView.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 3/26/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit


class SingleServiceView: UIViewController {
    
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceTitle: UINavigationBar!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var serviceAddress: UILabel!
    @IBOutlet weak var serviceDescription: UITextView!
    @IBOutlet weak var serviceProviderName: UILabel!
    @IBOutlet weak var servicePhone: UILabel!
    @IBOutlet weak var serviceEmail: UILabel!
    
    
    
    @IBOutlet weak var horizontalLine: UIView!
    
    override func viewDidLoad() {
        
        horizontalLine.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        horizontalLine.layer.borderWidth = 1.0
        horizontalLine.layer.cornerRadius = 5
        
        
    }
}