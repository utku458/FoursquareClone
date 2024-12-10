//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Utku Altınay on 3.12.2024.
//

import Foundation
import UIKit


class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    
    private init(){}
}
