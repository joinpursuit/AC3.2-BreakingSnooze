//
//  LocationTableViewCell.swift
//  BreakingSnooze
//
//  Created by Cris on 1/11/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var locationPicker: UIPickerView!
    
    let geo = CLGeocoder()
    let userDefaults = UserDefaults.standard
    
    let pickerData = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
    }
    
    func setPickerState(state: Int) {
        let state = pickerData[state]
        guard let index = pickerData.index(of: state) else { return }
        self.locationPicker.selectRow(index, inComponent: 1, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let state = pickerData[row]
        
        geo.geocodeAddressString(state) { (placemarkArr, eror) in
            guard let placemark = placemarkArr?[0] else { return }
            let latCoordinate = placemark.location?.coordinate.latitude
            let longCoordinate = placemark.location?.coordinate.longitude
            
            let latCoord =  String(format: "%0.4f", latCoordinate!)
            let longCoord = String(format: "%0.4f", longCoordinate!)
            
            let locationDict: [String : Any] = ["latCoord" : latCoord,
                                                "longCoord" : longCoord,
                                                "didSetOwnLocation" : true
            ]
            self.userDefaults.set(locationDict, forKey: "locationSave")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
