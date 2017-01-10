//
//  Weather.swift
//  BreakingSnooze
//
//  Created by Kadell on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

enum errorEnum: Error {
    case coord, long,lat,icon,name, weather, sys, country, main,temp
}

class Weather {
    
    let longitude: Double
    let latitude: Double
    let icon: String
    let name: String
    let country: String
    let temp: Double
    
    init(longitude: Double, latitude: Double, icon: String, name: String, country: String, temp: Double) {
        self.longitude = longitude
        self.latitude = latitude
        self.icon = icon
        self.name = name
        self.country = country
        self.temp = temp
    }
    
    static func getData(from data: Data) -> [Weather]? {
        do{
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dict = jsonData as? [String: Any] else {return nil}
            guard let coordinates = dict["coord"] as? [String : Any] else { throw errorEnum.coord}
            
            guard let long = coordinates["lon"] as? Double else { throw errorEnum.long}
            guard let lat = coordinates["lat"] as? Double else {throw errorEnum.lat}
            guard let weather = dict["weather"] as? [[String: Any]] else { throw errorEnum.weather}
            guard let name = dict["name"] as? String else {throw errorEnum.name}
            guard let sys = dict["sys"] as? [String: Any] else {throw errorEnum.sys}
            guard let country = sys["country"] as? String else {throw errorEnum.country}
            guard let main = dict["main"] as? [String: Double] else {throw errorEnum.main}
            guard let temp = main["temp"] else {throw errorEnum.temp}
            
            var weatherIcon = ""
            for items in weather {
                guard let icon = items["icon"] as? String  else {throw errorEnum.icon}
                weatherIcon += icon
            }
            let weatherOf = [Weather(longitude: long, latitude: lat, icon: weatherIcon, name: name, country: country, temp:temp)]
            return weatherOf
            
        }
        catch {
            print("Normal")
        }
        return nil
    }
    
}
