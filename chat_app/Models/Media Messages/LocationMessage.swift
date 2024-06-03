//
//  LocationMessage.swift
//  chat_app
//
//  Created by KhoaLA8 on 23/5/24.
//

import Foundation
import MessageKit
import CoreLocation

class LocationMessage: NSObject, LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
    
}
