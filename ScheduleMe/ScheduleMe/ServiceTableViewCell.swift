//
//  ServiceTableViewCell.swift
//  ScheduleMe
//
//  Created by Dan Morain on 3/23/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setImageTo(filename: String) {
        self.serviceImage.image = UIImage(named: filename)
        self.serviceImage.contentMode = .ScaleAspectFill
        self.serviceImage.layer.cornerRadius = self.serviceImage.frame.size.width / 2;
        self.serviceImage.clipsToBounds = true;
    }
    
}
