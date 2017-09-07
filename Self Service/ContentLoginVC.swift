//
//  ContentLoginVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/4/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class ContentLoginVC: UIViewController, UITextFieldDelegate {

    weak var contentLoginDelegate: LoginVC!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.txtUser.delegate = self
        self.txtPassword.delegate = self
        
        self.btnLogin.layer.cornerRadius = 5.0
        self.btnLogin.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: UIButton) {
        if (self.txtUser.text != "" && self.txtPassword.text != "") {
            self.contentLoginDelegate.loginToLDAP(self.txtUser.text!, password: self.txtPassword.text!)
        }
    }
    
    /*
    // MARK - UITEXTFIELD DELEGATE
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtUser) {
            self.txtPassword.becomeFirstResponder()
        }else{
            if (self.txtUser.text != "" && self.txtPassword.text != "") {
                self.txtPassword.resignFirstResponder()
                self.contentLoginDelegate.loginToLDAP(self.txtUser.text!, password: self.txtPassword.text!)
            }
        }
        
        return true
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
