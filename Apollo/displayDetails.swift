//
//  displayDetails.swift
//  
//
//  Created by Kevin Thwaits on 4/18/18.
//

import UIKit
import MessageUI


class displayDetails: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var isDJ:Bool?
    var DJInfo:UserObject?
    var listeners:Array<UserObject>?
    var partyCode:String?

    @IBOutlet var seperatorLabel: UILabel!
    @IBOutlet var tapToDismiss: UILabel!
    @IBOutlet var djPic: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        weak var pvc = self.presentingViewController
        if (isDJ)! {
            self.dismiss(animated: false, completion: { pvc?.performSegue(withIdentifier: "partyToDJ", sender: nil)})
        } else {
            self.dismiss(animated: false, completion: { pvc?.performSegue(withIdentifier: "partyToListener", sender: nil)})
        }
    }
    
    @IBAction func djSync(_ sender: AnyObject) {
       NotificationCenter.default.post(name: Notification.Name(rawValue: "sync"), object: nil)
    }
    @IBAction func shareButton(_ sender: Any) {
        let controller = MFMessageComposeViewController()
        if (MFMessageComposeViewController.canSendText()) {
            let code = partyCode
            controller.body = "Hey join my apollo party with this code! \(code ?? "123456")"
            
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissTapped(tapGestureRecognizer:)))
        tapToDismiss.addGestureRecognizer(tapGestureRecognizer)
        tapToDismiss.isUserInteractionEnabled = true
        
        djPic.layer.borderColor = UIColor(red:0.35, green:0.33, blue:0.64, alpha:1.0).cgColor
        if ((DJInfo?.images) != nil) {
        djPic.downloadedFrom(link: (DJInfo?.images)!)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateListenerArray"), object: nil)
        if ((listeners) != nil) {
            for (index, user) in (listeners?.enumerated())! {
                let userPic = UIButton(type: UIButtonType.custom) as UIButton
                let seperatorXPosition = Int(seperatorLabel.frame.maxX + 15)
                let djHeight = djPic.frame.height
                let spaceBetweenImages = Int(djHeight*(4/3))
                let xPosition: CGFloat = CGFloat(seperatorXPosition + (index * spaceBetweenImages))
                let djYPosition = djPic.frame.minY
                let yPosition: CGFloat = djYPosition + 2
                
                let buttonWidth: CGFloat = djHeight * (14/15)
                let buttonHeight: CGFloat = djHeight * (14/15)
                userPic.frame = CGRect(x: xPosition, y: yPosition, width: buttonWidth, height: buttonHeight)
                userPic.setImage(#imageLiteral(resourceName: "blankProfilePic"), for: .normal)
                userPic.layer.cornerRadius = djHeight/2
                userPic.layer.masksToBounds = true
                if (user.images.count > 5) {
                    userPic.downloadedFrom(link: (user.images))
                }
                self.view.addSubview(userPic)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: {})
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


    }


}
