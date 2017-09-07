//
//  PersonalInfoSheetVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/20/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class PersonalInfoSheetVC: UIViewController, UITextFieldDelegate {

    let fullView: CGFloat = 68
    var partialView: CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    var keyboardFrame: CGRect!
    weak var personalInfoSheetDelegate: PersonalInfoVC!
    @IBOutlet weak var txtSearchPersonalInfo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(PersonalInfoSheetVC.keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(PersonalInfoSheetVC.swipeGesturePersonalInfoSheet))
        self.view.addGestureRecognizer(gesture)
        
        self.txtSearchPersonalInfo.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.3, animations: { [weak self] in
            let yComponent = UIScreen.mainScreen().bounds.height - 44
            self!.view.frame = CGRect(x: 0, y: yComponent, width: (self?.view.frame.width)!, height: (self?.view.frame.height)!)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipeGesturePersonalInfoSheet(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocityInView(self.view)
        if (velocity.y >= 0) {
            UIView.animateWithDuration(0.3, animations: { [weak self] in
                let frame = self?.view.frame
                let yComponent = UIScreen.mainScreen().bounds.height - 44
                self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
                })
        }else{
            UIView.animateWithDuration(0.3, animations: { [weak self] in
                let frame = self?.view.frame
                let yComponent = UIScreen.mainScreen().bounds.height - 88
                self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
                })
        }
        
    }
    
    func searchPersonalInfoFromSheet(kword: String) {
        if (self.personalInfoSheetDelegate.isKindOfClass(PersonalInfoVC)) {
            self.personalInfoSheetDelegate.searchWord = kword
            self.personalInfoSheetDelegate.prevSize = 0
            self.personalInfoSheetDelegate.isMaxSize = false
            self.personalInfoSheetDelegate.getPersonalInfoData(kword, start: 0, limit: 20)
            self.personalInfoSheetDelegate.movedPersonalInfoViewUp(false)
        }
    }
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        keyboardFrame = view.convertRect(rawFrame, fromView: nil)
                
        print("keyboardFrame: \(keyboardFrame)")
    }
    
    /*
    // MARK - UITEXTFIELD DELEGATE
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtSearchPersonalInfo) {
            self.searchPersonalInfoFromSheet(textField.text!)
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == self.txtSearchPersonalInfo) {
            self.personalInfoSheetDelegate.movedPersonalInfoViewUp(true)
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
