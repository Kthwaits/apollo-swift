//
//  ViewController.swift
//  Apollo
//
//  Created by Kevin Thwaits on 4/5/18.
//  Copyright © 2018 Kevin Thwaits. All rights reserved.
//

import UIKit
import SafariServices

@objcMembers class ViewController: UIViewController {
    var access_token = "This should not be printed"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signInButtonPressed(_ sender: Any) {
        let appURL = SPTAuth.defaultInstance().spotifyAppAuthenticationURL()
        let webURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()!
        
        
        // Before presenting the view controllers we are going to start watching for the notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receievedUrlFromSpotify(_:)),
                                               name: NSNotification.Name.Spotify.authURLOpened,
                                               object: nil)
        
        if SPTAuth.supportsApplicationAuthentication() {
            UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
        } else {
            present(SFSafariViewController(url: webURL), animated: true, completion: nil)
        }
    }
    
    
    func receievedUrlFromSpotify(_ notification: Notification) {
        guard let url = notification.object as? URL else { return }
        let hashedParameters = url.absoluteString
        let newString = hashedParameters.replacingOccurrences(of: "#", with: "?")
        let newURL = URL(string: newString)!
        access_token = newURL.valueOf("access_token")!
        successfulLogin()
        
        SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url) { (error, session) in
            //Check if there is an error because then there won't be a session.
            if let error = error {
                print(error)
                return
            }
            
        }
        
    }
    
    func displayErrorMessage(error: Error) {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func successfulLogin() {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            // Present next view controller or use performSegue(withIdentifier:, sender:)
            self.performSegue(withIdentifier: "successfullLogin", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destinationVC = segue.destination as? MainViewController {
                destinationVC.access_token = access_token
            }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

