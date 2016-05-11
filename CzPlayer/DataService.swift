//
//  DataService.swift
//  CzPlayer
//
//  Created by Dominik on 5/8/16.
//  Copyright © 2016 Dominik Vltavsky. All rights reserved.
//

import Foundation

class DataServices {
func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func addSecondsToCurrentTime(seconds: Int) -> Int {
    
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Hour, .Minute], fromDate: date)
    let hour = components.hour*60*60
    let minute = components.minute*60
    
    return hour+minute+seconds
    
}

// let (h,m,s) = secondsToHoursMinutesSeconds(27005)


    
    //*************************
    // getTravelTime
    //************************
    
func getTravelTime(){
    print("getTravelTime")
    
    var destination:String!
    var destinationTitle:String!
    
    
    let work = "715+Harrison,San+Sanfrisco"
    let home = "2021+Alden,94002"
    
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(.Hour, fromDate: date)
    let hour = components.hour
    
    //Going to work?
    if hour < 12 {
        print("work")
        destination = work
        destinationTitle = "W "
    } else {
        destination = home
        destinationTitle = "H "
    }
    
    
    if RadioPlayer.sharedInstance.latitude != 0.0 {
        let toWork = "https://maps.googleapis.com/maps/api/directions/json?traffic_model=best_guess&departure_time=now&origin=\(RadioPlayer.sharedInstance.latitude),\(RadioPlayer.sharedInstance.longitude)&destination=\(destination)&key=AIzaSyCoKpjFl-j7eA2iWoLg1q7qRvrgnyHgafU"
        
        let myURL = NSURL(string: toWork)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(myURL!){ (data, response, error) -> Void in
            
            if let urlConent = data {
                do {
                    let parsed_json = try NSJSONSerialization.JSONObjectWithData(urlConent, options: NSJSONReadingOptions.MutableContainers)
                    //print(parsed_json)
                    let duration = parsed_json.valueForKeyPath("routes.legs.duration_in_traffic.value") as! NSArray
                    
                    print ("**************duration = \(duration[0])")
                    let d1 = duration[0] as! [NSNumber]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.tableView.reloadData()
                        let d2 = d1[0] as! Int
                        let (h,m,s) = self.secondsToHoursMinutesSeconds( self.addSecondsToCurrentTime(d2))
                        RadioPlayer.sharedInstance.arriveTime = destinationTitle + String(h) + ":" + String(m)
                        RadioPlayer.sharedInstance.travelTime = String(d2/60) + "min"
                        RadioPlayer.sharedInstance.updateDisplay()
                    })
                    
                } catch {
                    print("Error reading JSON")
                } //do
            } //let
        }//task
        
        task.resume()
    } // if
}
    
    
    //*************************
    // getWeather
    //************************
    func getWeather() {
        print("getWeather")
        
        let myURL = NSURL(string: "http://bigpi.info:500/weatherJson.php")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        
        // Compose a query string
        let postString = "offset=" + String(0);
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            if let urlConent = data {
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlConent, options: NSJSONReadingOptions.MutableContainers)
                    
                    let date = jsonResult["date"] as! String
                    let outTemp = jsonResult["outTemp"]as! Double
                    let windGust = jsonResult["windGust"] as! Double
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        print("getWeather = \(outTemp)")
                        RadioPlayer.sharedInstance.weatherInfo = (NSString(format: "%.1f", outTemp) as String) + " º  " + (NSString(format: "%.0f", windGust) as String) + " mph"
                        //self.lastUpdated.text = date
                        
                    })
                    
                } catch {
                    print("Error reading JSON")
                } //do
            } //let
        }//task
        
        task.resume()
        
    }

}