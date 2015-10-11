//
//  ViewController.swift
//  CzPlayer
//
//  Created by Dominik Vltavsky on 10/10/15.
//  Copyright © 2015 Dominik Vltavsky. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


class ViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playButton.setTitle("Play", forState: UIControlState.Normal)

        
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [MPMediaItemPropertyArtist : "Artist!",  MPMediaItemPropertyTitle : "Title!"]
        
       _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
          UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
           
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buttonPressed1(sender: AnyObject) {
           toggle()
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        toggle()
    }
    
    func toggle() {
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            pauseRadio()
        } else {
            playRadio()
        }
    }
    
    func playRadio() {
        RadioPlayer.sharedInstance.play()
        playButton.setTitle("Pause", forState: UIControlState.Normal)
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        playButton.setTitle("Play", forState: UIControlState.Normal)
    }
}

