//
//  RadioPlayer.swift
//  CzPlayer
//
//  Created by Dominik Vltavsky on 10/10/15.
//  Copyright © 2015 Dominik Vltavsky. All rights reserved.
//

import Foundation
import AVFoundation

class RadioPlayer {
    static let sharedInstance = RadioPlayer()
    //private var player = AVPlayer(URL: NSURL(string: "http://www.radiobrasov.ro/listen.m3u")!)
    //http://icecast5.play.cz/impuls128.mp3
    private var player = AVPlayer(URL: NSURL(string: "http://icecast5.play.cz/impuls128.mp3")!)
    private var isPlaying = false
    
    func play() {
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
