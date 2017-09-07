//
//  ContentForgotVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/4/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class ContentForgotVC: UIViewController {

    weak var contentForgotDelegate: LoginVC!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnSubmit.layer.cornerRadius = 5.0
        self.btnSubmit.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPassword(sender: UIButton) {
        if (self.txtEmail.text != "") {
            self.contentForgotDelegate.submitResetPassword(self.txtEmail.text!)
        }
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
