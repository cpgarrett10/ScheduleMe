//
//  SingleServiceView.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 3/26/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit


class SingleServiceViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceTitle: UINavigationBar!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var serviceAddress: UILabel!
    @IBOutlet weak var serviceDescription: UITextView!
    @IBOutlet weak var serviceProviderName: UILabel!
    @IBOutlet weak var servicePhone: UILabel!
    @IBOutlet weak var serviceEmail: UILabel!
    
    @IBOutlet weak var horizontalLine: UIView!
    
    var service: Service?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHorizontalLine()
        
        if let service = service {
            initComponents(service)
        }
    }
    
    func initHorizontalLine() {
        horizontalLine.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        horizontalLine.layer.borderWidth = 1.0
        horizontalLine.layer.cornerRadius = 5
    }
    
    func initComponents(service: Service) {
        serviceImage.image = service.image
        serviceTitle.topItem?.title = service.title
        servicePrice.text = "$" + service.price
        serviceAddress.text = service.streetAddress
        serviceDescription.text = service.description
        serviceProviderName.text = service.uid
        servicePhone.text = service.phone
        serviceEmail.text = service.serviceEmail
        
    }
    
    // MARK: Action
    
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
}