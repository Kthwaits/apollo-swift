//
//  ListenerCodeViewController.swift
//  Apollo
//
//  Created by Kevin Thwaits on 4/7/18.
//  Copyright © 2018 Kevin Thwaits. All rights reserved.
//

import UIKit

class ListenerCodeViewController: UIViewController, UITextFieldDelegate {

    var access_token:String?
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var enterCode: UITextField!
    
    @IBAction func joinButton(_ sender: Any) {
        if (enterCode.text?.count == 6) {
            self.performSegue(withIdentifier: "listenerToParty", sender: self)
        }
        else {
            errorLabel.text = "Code must be 6 digits."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        
        enterCode.borderStyle = .none
        enterCode.layoutIfNeeded()
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        
        border.frame = CGRect(x: 0, y: enterCode.frame.size.height - width, width:  enterCode.frame.size.width, height: enterCode.frame.size.height)
        border.borderWidth = width
        
        enterCode.layer.addSublayer(border)
        enterCode.layer.masksToBounds = true
        enterCode.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "listenerToMain", sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.text = ""
        enterCode.becomeFirstResponder()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PartyViewController {
            destinationVC.partyCode = enterCode.text
            destinationVC.access_token = access_token
            destinationVC.isDJ = false
        }
        if let destinationVC = segue.destination as? MainViewController {
            destinationVC.access_token = access_token
        }
    }


}
