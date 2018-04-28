//
//  PartyViewController.swift
//  Apollo
//
//  Created by Kevin Thwaits on 4/7/18.
//  Copyright © 2018 Kevin Thwaits. All rights reserved.
//

import UIKit
import SocketIO
import MarqueeLabel

class PartyViewController: UIViewController {
    var access_token:String?
    var partyCode:String?
    var isDJ:Bool?
    var progress:String?
    var duration: String?
    var spotifyHooks: String?
    var fetchDataTimer: Timer?
    var psuedoTimer: Timer?
    var currentProgressInMS: Int?
    var totalTimeInMS: Int?
    var profileImage: String?
    var DJInfo: UserObject?
    var listeners: [UserObject]?
    
    let manager = SocketManager(socketURL: URL(string: "http://whispering-fjord-50685.herokuapp.com/")!,config: [.log(false)])
    var socket:SocketIOClient!
    
    @IBOutlet var albumArt: UIImageView!
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var totalTime: UILabel!
    @IBAction func spotifyButton(_ sender: Any) {
        let spotifyUrl = NSURL(string: spotifyHooks!)
        if UIApplication.shared.canOpenURL(spotifyUrl! as URL)
        {
            UIApplication.shared.open(spotifyUrl! as URL, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.open(NSURL(string: "http://spotify.com/")! as URL, options: [:], completionHandler: nil)
        }
        if (isDJ == false){
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.socket.emit("sync")
            }
            
        }
    }
    
    @IBOutlet var displaySpotifyButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket = manager.defaultSocket
        self.setSocketEvents()
        self.socket.connect()
        
        NotificationCenter.default.addObserver(self, selector: #selector(manualSync(_:)), name: Notification.Name(rawValue: "sync"), object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
        albumArt.addGestureRecognizer(tapGestureRecognizer)
        albumArt.isUserInteractionEnabled = true
        if (isDJ)! {
            spotifyHooks = "https://open.spotify.com/"
        } else {
            spotifyHooks = "https://open.spotify.com/track/7oK9VyNzrYvRFo7nQEYkWN?si=CiuD_e5hQCGKQ0kdC74MeQ"
        }
        
        fetchDataTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (Timer) in
            self.updatePlaying()
        })
        psuedoTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            self.updatePseudoTimer()
        })
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 2)
    
    }

    private func setSocketEvents()
    {
        self.socket.on(clientEvent: .connect) {data, ack in
            self.socket.emit("room", self.partyCode!)
            if(self.isDJ)! {
                self.socket.emit("dj", ["access_token": self.access_token, "socket_id": self.socket.sid, "room": self.partyCode])

            }
            else {
                self.socket.emit("listener", ["access_token": self.access_token, "socket_id": self.socket.sid, "room": self.partyCode])
            }
            self.socket.emit("getDJProfile", self.partyCode!)
        }
        
        self.socket.on("currentlyPlaying") {(response, ack) -> Void in
            let response = response[0]  as? String
            do {
                let json = response?.data(using: .utf8)!
                let decoder = JSONDecoder()
                let currentlyPlayingInfo = try decoder.decode(CurrentlyPlayingObject.self, from: json!)
                if (currentlyPlayingInfo.song != "none") {
                self.albumArt.downloadedFrom(link: currentlyPlayingInfo.albumArt)
                self.songLabel.text = currentlyPlayingInfo.song
                self.artistLabel.text = currentlyPlayingInfo.artist
                self.progressBar.isHidden = false
                self.currentTime.isHidden = false
                self.totalTime.isHidden = false
                self.currentProgressInMS = currentlyPlayingInfo.position
                self.totalTimeInMS = currentlyPlayingInfo.duration
                self.currentTime.text = self.convertMSToString(MS: self.currentProgressInMS!)
                self.totalTime.text = self.convertMSToString(MS: self.totalTimeInMS!)
                    self.progressBar.setProgress((Float(self.currentProgressInMS!)/Float(self.totalTimeInMS!)), animated: true)
                self.albumArt.alpha = 1
                } else {
                    if (self.isDJ! != true) {
                    self.displaySpotifyButton.setTitle("Open Spotify to Join", for: .normal)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        
        self.socket.on("DJInfo") {(response, ack) -> Void in
            let response = response[0]  as? String
            do {
                let json = response?.data(using: .utf8)!
                let decoder = JSONDecoder()
                self.DJInfo = try decoder.decode(UserObject.self, from: json!)

            } catch let err {
                print(err)
            }
        }
        
        self.socket.on("updateListeners") {(response, ack) -> Void in
            let response = response[0] as? String
            do {
                let json = response?.data(using: .utf8)!
                let decoder = JSONDecoder()
                let listeners = try decoder.decode([UserObject].self, from: json!)
                self.listeners = listeners
            }
            catch let err {
                print(err)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePlaying(){
        self.socket.emit("getCurrentlyPlaying", ["access_token": self.access_token, "socket_id": self.socket.sid, "room": self.partyCode])
    }
  
    @objc func manualSync(_ notification: Notification) {
        self.socket.emit("sync")
    }

    @objc func updateListenersArray(_ notification: Notification) {
        self.socket.emit("getListeners")
    }
    
    //counts progress of song locally so that api requests can be limited
    func updatePseudoTimer() {
        if self.currentProgressInMS != nil {
            let newTimeInMS = self.currentProgressInMS! + 1000
        currentProgressInMS = newTimeInMS
            if (currentProgressInMS! <= self.totalTimeInMS!){
                self.progressBar.setProgress((Float(currentProgressInMS!)/Float(self.totalTimeInMS!)), animated: true)
        self.currentTime.text = self.convertMSToString(MS: newTimeInMS)
        }
        }

    }
    
    
    func convertMSToString(MS: Int) -> String {
        let ms = MS
        let timestampString = (ms.msToSeconds).minuteSecondMS
        return timestampString
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "showDetails", sender: self)
        
        // Your action
    }
    // MARK: - Navigation

    override func viewWillAppear(_ animated: Bool) {
        fetchDataTimer?.fire()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? displayDetails {
            destinationVC.isDJ = isDJ
            destinationVC.DJInfo = DJInfo
            destinationVC.listeners = listeners
            destinationVC.partyCode = partyCode
        }
        if let destinationVC = segue.destination as? ListenerCodeViewController {
            destinationVC.access_token = access_token
        }
        if let destinationVC = segue.destination as? DJCodeViewController {
            destinationVC.access_token = access_token
            destinationVC.generatedCode = partyCode
        }
    }

}
