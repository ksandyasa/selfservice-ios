//
//  ViewController.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 12/31/16.
//  Copyright © 2016 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController, UITabBarDelegate {

    var contentLoginVC: ContentLoginVC!
    var mainVC: MainVC!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginTabBar: UITabBar!
    @IBOutlet weak var contentLoginTabBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.hidden = true
        if self.navigationController!.respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            self.navigationController!.view.removeGestureRecognizer(self.navigationController!.interactivePopGestureRecognizer!)
        }
        
        self.loginTabBar.delegate = self
        self.tabBar(self.loginTabBar, didSelectItem: self.contentLoginTabBarItem)
        self.loginTabBar.selectedItem = self.contentLoginTabBarItem
        self.contentLoginTabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "MetroNovaPro-Medium", size: 17)!,
            NSForegroundColorAttributeName: SelfServiceUtility.colorWithHexString("FFFFFF")], forState: .Normal)
        self.contentLoginTabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "MetroNovaPro-Regular", size: 17)!,
            NSForegroundColorAttributeName: SelfServiceUtility.colorWithHexString("FFFFFF")], forState: .Selected)
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") != nil) {
            print(NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs"))
            let apiToken = NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs")
            if (apiToken as! String != "") {
                let userData = (NSUserDefaults.standardUserDefaults().objectForKey("userDataPrefs") as? NSData)!
                GlobalVariable.sharedInstance.itemLogin = (NSKeyedUnarchiver.unarchiveObjectWithData(userData) as? Array<AnyObject>)!
                print(GlobalVariable.sharedInstance.itemLogin.description)
                self.mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainVC") as! MainVC
                self.navigationController?.pushViewController(self.mainVC, animated: false)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginToLDAP(username: String, password: String) {
        SelfServiceUtility.showLoadingView(self.view)
        let params = ["npp" : username, "password" : password
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_LOGIN, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    GlobalVariable.sharedInstance.itemLogin = (JSON["data"] as? Array<AnyObject>)!
                    print(GlobalVariable.sharedInstance.itemLogin.description)
                    let saveArray: NSData = NSKeyedArchiver.archivedDataWithRootObject(GlobalVariable.sharedInstance.itemLogin)
                    NSUserDefaults.standardUserDefaults().setObject(GlobalVariable.sharedInstance.itemLogin[0]["api_token"] as! String, forKey: "apiTokenPrefs")
                    NSUserDefaults.standardUserDefaults().setObject(username, forKey: "usernamePrefs")
                    NSUserDefaults.standardUserDefaults().setObject(password, forKey: "passwordPrefs")
                    NSUserDefaults.standardUserDefaults().setObject(saveArray, forKey: "userDataPrefs")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    SelfServiceUtility.hideLoadingView(self.view)
                    self.mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainVC") as! MainVC
                    self.navigationController?.pushViewController(self.mainVC, animated: true)
                }
        }
    }
    
    func submitResetPassword(email: String) {
        
    }
    
    func setupContentLoginView() {
        if (contentLoginVC != nil) {
            contentLoginVC.view.removeFromSuperview()
            contentLoginVC.removeFromParentViewController()
            contentLoginVC = nil
        }
        contentLoginVC = ContentLoginVC(nibName: "ContentLoginVC", bundle: nil)
        contentLoginVC.contentLoginDelegate = self
        self.addChildViewController(contentLoginVC)
        contentLoginVC.view.frame = self.contentView.bounds
        self.contentView.addSubview(contentLoginVC.view)
        contentLoginVC.didMoveToParentViewController(self)
    }
    
    /*
    // MARK - UITABBAR DELEGATE
    */
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag {
        case 1:
            self.setupContentLoginView()
        default:
            self.setupContentLoginView()
        }
    }

}

