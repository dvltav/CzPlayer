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

class RadioPlayer {
    

    
     let  stations: [[String:String]] = [
        [
            "name": "Impuls",
            "url": "http://icecast5.play.cz/impuls128.mp3"
        ],
        [
            "name": "Frekvence 1",
            "url": "http://icecast3.play.cz/frekvence1-128.mp3"
        ]
]
    /*
        [
            "name": "",
            "url": "Rivera"
        ],
        [
            "name": "Sonja",
            "url": "Moreno"
        ],
        [
            "firstName": "Noel",
            "lastName": "Bowen"
        ]
    ]
*/

    
    static let sharedInstance = RadioPlayer()
    let speechSynthesizer = AVSpeechSynthesizer()
    
    private var player = AVPlayer()
    //private var player = nil
    private var isPlaying = false
    private var stationIndex = 0
    
    
    func test(){
        print( stations[0]["name"])
        //   var name = entry["name"]
    }
    
    func play() {
        if player.status != AVPlayerStatus.ReadyToPlay {
            play(stationIndex)
        } else {
        
            player.play()
            isPlaying = true
        }
        
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
        
        play(stationIndex)
    }
    
    func nextStation() {
        if stationIndex >= stations.count - 1 {
            stationIndex = 0
        } else {
            stationIndex++
        }
        
        play(stationIndex)
    }
    
    func play(i: Int  ) {
        var statInfo = stations[i]
        speak(statInfo["name"]!)
        player = AVPlayer(URL: NSURL(string: statInfo["url"]!)!)
         MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [ MPMediaItemPropertyTitle : statInfo["name"]!]
        player.play()
        isPlaying = true
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
