//
//  MainViewController.swift
//  Apollo
//
//  Created by Kevin Thwaits on 4/5/18.
//  Copyright © 2018 Kevin Thwaits. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var access_token:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    @IBAction func buttonPressed(_ sender: Any) {

    }
    
    @IBAction func listener(_ sender: Any) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DJCodeViewController {
            destinationVC.access_token = access_token
        }
        if let destinationVC = segue.destination as? ListenerCodeViewController {
            destinationVC.access_token = access_token
        }
    }

}
