//
//  MapPoint.swift
//  ScheduleMe
//
//  Created by Dan Morain on 4/1/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import MapKit
import AddressBook

class MapPoint: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String : AnyObject]()
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}
