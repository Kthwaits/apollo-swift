//
//  displayDetails.swift
//  
//
//  Created by Kevin Thwaits on 4/18/18.
//

import UIKit


class DisplayDetails: UIViewController {
    var isDJ:Bool?
    
    @IBOutlet var tapToDismiss: UILabel!
    @IBOutlet var djPic: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        if (isDJ == true){
            performSegue(withIdentifier: "partyToDJ", sender: self)
        } else {
            performSegue(withIdentifier: "partyToListener", sender: self)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissTapped(tapGestureRecognizer:)))
        tapToDismiss.addGestureRecognizer(tapGestureRecognizer)
        tapToDismiss.isUserInteractionEnabled = true
        
        djPic.layer.borderColor = UIColor(red:0.35, green:0.33, blue:0.64, alpha:1.0).cgColor
    }

    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: {})
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
