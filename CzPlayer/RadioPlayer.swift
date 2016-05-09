//
//  RadioPlayer.swift
//  CzPlayer
//
//  Created by Dominik Vltavsky on 10/10/15.
//  Copyright © 2015 Dominik Vltavsky. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import CoreLocation

class RadioPlayer {
    

    
     let  stations: [[String:String]] = [
        [
            "name": "Impuls",
            "url": "http://icecast5.play.cz/impuls128.mp3",
            "image": "impuls.png"
        ],
        [
            "name": "Frekvence 1",
            "url": "http://icecast3.play.cz/frekvence1-128.mp3",
            "image": "frekvence1.png"
        ],
    
        [
            "name": "Radio Zurnal",
            "url": "http://icecast8.play.cz/cro1-128.mp3",
            "image": "cro1.png"
        ],
        [
            "name": "Kiss Hady",
            "url": "http://icecast4.play.cz/kissjc128.mp3",
            "image": "kissjc.png"
        ]
    ]
    /*
        [
            "firstName": "Noel",
            "lastName": "Bowen"
        ]
    ]
*/

    
    static let sharedInstance = RadioPlayer()
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var weatherInfo: String = "none"
    var travelTime: String = "no travel"
    
    var latitude:CLLocationDegrees = 0
    
    var longitude:CLLocationDegrees = 0
    
    
     var player = AVPlayer()
    //private var player = nil
     var isPlaying = false
     var stationIndex = 0
    
    
    func test(){
        print( stations[0]["name"])
        //   var name = entry["name"]
    }
    
    func play() {
       // if player.status != AVPlayerStatus.ReadyToPlay {
            playAtIndex()
            isPlaying = true
    }
    
    func speak(speach: String) {
        let speechUtterance = AVSpeechUtterance(string: speach)
        speechSynthesizer.speakUtterance(speechUtterance)
    }
    
    func prevStation() {
        if stationIndex == 0 {
            stationIndex = stations.count - 1
        } else {
            stationIndex--
        }
        
        playAtIndex()
    }
    
    func nextStation() {
        if stationIndex >= stations.count - 1 {
            stationIndex = 0
        } else {
            stationIndex++
        }
        
        playAtIndex()
    }
    
    func playAtIndex( ) {
        var statInfo = stations[stationIndex]
        player = AVPlayer(URL: NSURL(string: statInfo["url"]!)!)
        updateDisplay()
        player.play()
        isPlaying = true
        MPNowPlayingInfoCenter.defaultCenter()
    }
    
    func updateDisplay() {
        var statInfo = stations[stationIndex]
        
        let albumArtWork = MPMediaItemArtwork(image: UIImage(named: statInfo["image"]!)!)
        albumArtWork.imageWithSize(CGSize(width: 200,height: 200))
        
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo =
            [MPMediaItemPropertyArtist : weatherInfo,
             MPMediaItemPropertyTitle : statInfo["name"]!,
             MPMediaItemPropertyGenre : "genre",
             MPMediaItemPropertyAlbumTitle : travelTime,
             MPMediaItemPropertyArtwork : albumArtWork
        ]
    }
    
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func toggle() {
        if isPlaying == true {
            pause()
        } else {
            play()
        }
    }
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }
    
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
                        self.weatherInfo = (NSString(format: "%.1f", outTemp) as String) + " º  " + (NSString(format: "%.0f", windGust) as String) + " mph"
                        //self.lastUpdated.text = date
 
                    })
                    
                } catch {
                    print("Error reading JSON")
                } //do
            } //let
        }//task
        
        task.resume()
        
    }
    
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
            destinationTitle = "Work "
        } else {
            destination = home
            destinationTitle = "Home "
        }
        
        
        if latitude != 0.0 {
        let toWork = "https://maps.googleapis.com/maps/api/directions/json?origin=\(latitude),\(longitude)&destination=\(destination)&key=AIzaSyCoKpjFl-j7eA2iWoLg1q7qRvrgnyHgafU"
            
        let myURL = NSURL(string: toWork)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(myURL!){ (data, response, error) -> Void in
            
            if let urlConent = data {
                do {
                    let parsed_json = try NSJSONSerialization.JSONObjectWithData(urlConent, options: NSJSONReadingOptions.MutableContainers)
                    //print(parsed_json)
                    let duration = parsed_json.valueForKeyPath("routes.legs.duration.text") as! NSArray

                    print ("**************duration = \(duration[0])")
                    let d1 = duration[0] as! [NSString]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.tableView.reloadData()
                       self.travelTime = destinationTitle + (d1[0] as! String)
                        self.updateDisplay()
                    })
                    
                } catch {
                    print("Error reading JSON")
                } //do
            } //let
        }//task
        
        task.resume()
        } // if
    }
    

}
