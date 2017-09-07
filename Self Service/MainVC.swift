//
//  MainVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 12/31/16.
//  Copyright © 2016 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, YALContextMenuTableViewDelegate {
    
    let menuCellIdentifier = "rotationCell"
    var menuMain: Array<AnyObject>!
    var menuIndeks: Int = 0
    var contextMenuTableView: YALContextMenuTableView?
    var profilVC: ProfilVC!
    var slipGajiVC: SlipGajiVC!
    var personalInfoVC: PersonalInfoVC!
    var mainMenuColor: String!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnMainMenu: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuMain = SelfServiceUtility.getContextMenuList()
        
        self.contextMenuTableView = YALContextMenuTableView(tableViewDelegateDataSource: self)
        self.contextMenuTableView!.animationDuration = 0.05;
        self.contextMenuTableView!.yalDelegate = self
        self.contextMenuTableView?.registerNib(UINib(nibName: "ContextMenuCell", bundle: nil), forCellReuseIdentifier: menuCellIdentifier)
        
        self.mainMenuColor = "FFFFFF"
        self.setupProfilView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.contextMenuTableView!.reloadData()
    }
    
//    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration:duration)
//        
//        self.contextMenuTableView!.updateAlongsideRotation()
//    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition(nil, completion: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.contextMenuTableView!.reloadData()
        })
        
        self.contextMenuTableView!.updateAlongsideRotation()
    }
    
    func contextMenuTableView(contextMenuTableView: YALContextMenuTableView!, didDismissWithIndexPath indexPath: NSIndexPath!) {
        print("Menu dismissed with indexpath = \(indexPath)")
        if (indexPath.row == 1) {
            self.setupProfilView()
        }else if (indexPath.row == 2) {
            self.setupSlipGajiView()
        }else if (indexPath.row == 3) {
            self.setupCutiView()
        }else if (indexPath.row == 4) {
            self.setupLemburView()
        }else if (indexPath.row == 5) {
            self.setupSPPDView()
        }else if (indexPath.row == 6) {
            self.setupPersonalInfoView()
        }else{
            self.changeButtonsAndMenuColor(self.mainMenuColor)
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        contextMenuTableView!.dismisWithIndexPath(indexPath)
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuMain.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contextMenuTableView!.dequeueReusableCellWithIdentifier(menuCellIdentifier, forIndexPath:indexPath) as! ContextMenuCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.lblContextMenu.text = menuMain[indexPath.row]["menuLabel"] as? String
        cell.ivContextMenu.image = UIImage(named: (menuMain[indexPath.row]["menuIcon"] as? String)!)
        cell.ivContextMenu.image = cell.ivContextMenu.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.ivContextMenu.tintColor = SelfServiceUtility.colorWithHexString(mainMenuColor)
        
        return cell;
    }
    
    func removeAllSubviews() {
        if (profilVC != nil) {
            profilVC.view.removeFromSuperview()
            profilVC.removeFromParentViewController()
            profilVC = nil
        }
        if (slipGajiVC != nil) {
            slipGajiVC.view.removeFromSuperview()
            slipGajiVC.removeFromParentViewController()
            slipGajiVC = nil
        }
        if (personalInfoVC != nil) {
            personalInfoVC.view.removeFromSuperview()
            personalInfoVC.removeFromParentViewController()
            personalInfoVC = nil
        }
    }
    
    func setupProfilView() {
        self.menuIndeks = 1
        self.mainMenuColor = "FFFFFF"
        self.changeButtonsAndMenuColor(self.mainMenuColor)

        self.removeAllSubviews()
        
        profilVC = ProfilVC(nibName: "ProfilVC", bundle: nil)
        self.addChildViewController(profilVC)
        profilVC.view.frame = self.mainContainer.bounds
        self.mainContainer.addSubview(profilVC.view)
        self.mainContainer.sendSubviewToBack(profilVC.view)
        profilVC.didMoveToParentViewController(self)
    }
    
    func setupSlipGajiView() {
        self.menuIndeks = 2
        self.mainMenuColor = "FF210C"
        self.changeButtonsAndMenuColor(self.mainMenuColor)
        
        self.removeAllSubviews()
        
        slipGajiVC = SlipGajiVC(nibName: "SlipGajiVC", bundle: nil)
        self.addChildViewController(slipGajiVC)
        slipGajiVC.view.frame = self.mainContainer.bounds
        self.mainContainer.addSubview(slipGajiVC.view)
        self.mainContainer.sendSubviewToBack(slipGajiVC.view)
        slipGajiVC.didMoveToParentViewController(self)
    }
    
    func setupCutiView() {
        self.menuIndeks = 3
        self.mainMenuColor = "00C853"
        self.changeButtonsAndMenuColor(self.mainMenuColor)
    }
    
    func setupLemburView() {
        self.menuIndeks = 4
        self.mainMenuColor = "FFA726"
        self.changeButtonsAndMenuColor(self.mainMenuColor)
    }
    
    func setupSPPDView() {
        self.menuIndeks = 5
        self.mainMenuColor = "A1887F"
        self.changeButtonsAndMenuColor(self.mainMenuColor)
    }
    
    func setupPersonalInfoView() {
        self.menuIndeks = 6
        self.mainMenuColor = "FF210C"
        self.changeButtonsAndMenuColor(self.mainMenuColor)
        
        self.removeAllSubviews()
        
        personalInfoVC = PersonalInfoVC(nibName: "PersonalInfoVC", bundle: nil)
        self.addChildViewController(personalInfoVC)
        personalInfoVC.view.frame = self.mainContainer.bounds
        self.mainContainer.addSubview(personalInfoVC.view)
        self.mainContainer.sendSubviewToBack(personalInfoVC.view)
        personalInfoVC.didMoveToParentViewController(self)
    }
    
    func changeButtonsAndMenuColor(stringColor : String) {
        let homeImage = UIImage(named: "icon_home.png")?.imageWithRenderingMode(.AlwaysTemplate)
        let logoutImage = UIImage(named: "icon_logout.png")?.imageWithRenderingMode(.AlwaysTemplate)
        
        self.btnMainMenu.setImage(homeImage, forState: .Normal)
        self.btnMainMenu.tintColor = SelfServiceUtility.colorWithHexString(stringColor)
        
        self.btnLogout.setImage(logoutImage, forState: .Normal)
        self.btnLogout.tintColor = SelfServiceUtility.colorWithHexString(stringColor)
        
        self.contextMenuTableView!.reloadData()
    }

    @IBAction func logout(sender: UIButton) {
        self.mainMenuColor = "FFFFFF"
        self.changeButtonsAndMenuColor(self.mainMenuColor)
        
        if (self.menuIndeks != 1) {
            self.setupProfilView()
        }else{
            let alertController = UIAlertController(title: "Logout", message: "Keluar dari akun?", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ya", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                NSUserDefaults.standardUserDefaults().setObject("", forKey: "apiTokenPrefs")
                NSUserDefaults.standardUserDefaults().setObject("", forKey: "usernamePrefs")
                NSUserDefaults.standardUserDefaults().setObject("", forKey: "passwordPrefs")
                NSUserDefaults.standardUserDefaults().setObject("", forKey: "userDataPrefs")
                NSUserDefaults.standardUserDefaults().synchronize()
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
            let noAction = UIAlertAction(title: "Tidak", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(noAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func showContextMenu(sender: UIButton) {
        self.changeButtonsAndMenuColor(self.mainMenuColor)
        self.contextMenuTableView?.showInView(self.mainContainer, withEdgeInsets: UIEdgeInsetsZero, animated: true)
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
