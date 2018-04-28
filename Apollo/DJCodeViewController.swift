//
//  DJCodeViewController.swift
//  Apollo
//
//  Created by Kevin Thwaits on 4/7/18.
//  Copyright © 2018 Kevin Thwaits. All rights reserved.
//

import UIKit
import MessageUI

class DJCodeViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
         controller.dismiss(animated: true, completion: nil)
    }
    
    var access_token:String?
    var generatedCode:String?
    
    @IBOutlet var partyCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (generatedCode == nil) {
        generatedCode = generateCode()
        }
        partyCode.text = generatedCode
        partyCode.layoutIfNeeded()
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        
        border.frame = CGRect(x: 0, y: partyCode.frame.size.height - width, width:  partyCode.frame.size.width, height: partyCode.frame.size.height)
        border.borderWidth = width
        
        partyCode.layer.addSublayer(border)
        partyCode.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func generateCode() -> String {
        let digits: [Int] = Array(0...9).shuffled()
        let sixDigits = digits.prefix(6)
        let digitString = sixDigits.map { String($0) }.joined(separator: "")
        return(digitString)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let controller = MFMessageComposeViewController()
        if (MFMessageComposeViewController.canSendText()) {
            let code = generatedCode
            controller.body = "Hey join my apollo party with this code! \(code ?? "123456")"
            
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
    }
    }
    
        
    
    
    // MARK: - Navigation

    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "djToMain", sender: self)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PartyViewController {
            destinationVC.access_token = access_token
            destinationVC.partyCode = generatedCode
            destinationVC.isDJ = true
        }
        if let destinationVC = segue.destination as? MainViewController {
            destinationVC.access_token = access_token
        }
        
    }
    

}
