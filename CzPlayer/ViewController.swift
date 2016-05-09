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
import CoreLocation


class ViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    
    var manager:CLLocationManager!
    var ds:DataServices!
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // playButton.setTitle("Play", forState: UIControlState.Normal)

   
        initGPS()
        
        ds = DataServices()
        ds.getWeather()
        ds.getTravelTime()
        
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [MPMediaItemPropertyArtist : "Artist!",  MPMediaItemPropertyTitle : "Title!"]
        
       _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
          UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("wakeUp"), userInfo: nil, repeats: true)
    

    }
    
    func wakeUp() {
        print("wake up")
        //manager.requestLocation()
        if RadioPlayer.sharedInstance.isPlaying {
            manager.startUpdatingLocation()
            ds.getWeather()
            ds.getTravelTime()
        } else {
            manager.stopUpdatingLocation()
            RadioPlayer.sharedInstance.travelTime = "Paused"
            RadioPlayer.sharedInstance.updateDisplay()
        }
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = RadioPlayer.sharedInstance.stations[indexPath.item]["name"]
        let image : UIImage = UIImage(named: RadioPlayer.sharedInstance.stations[indexPath.item]["image"]!)!
        cell.imageView!.image = image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RadioPlayer.sharedInstance.stations.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        RadioPlayer.sharedInstance.stationIndex = indexPath.item
        RadioPlayer.sharedInstance.playAtIndex()
    }
    
  
    
    func initGPS() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.distanceFilter  = 50 //500meters
        //  manager.requestAlwaysAuthorization()
        //manager.requestLocation()
        manager.startUpdatingLocation()
        
    }
    //NOTE: [AnyObject] changed to [CLLocation]
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        //userLocation - there is no need for casting, because we are now using CLLocation object
        
        let userLocation:CLLocation = locations[0]
        
        RadioPlayer.sharedInstance.latitude = userLocation.coordinate.latitude
        
        RadioPlayer.sharedInstance.longitude = userLocation.coordinate.longitude
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}

