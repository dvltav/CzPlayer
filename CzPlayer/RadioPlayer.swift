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
    var arriveTime: String = "-:-"
    
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
             MPMediaItemPropertyGenre : travelTime,
             MPMediaItemPropertyAlbumTitle : arriveTime,
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
    

    

    

}
