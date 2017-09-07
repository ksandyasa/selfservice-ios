//
//  DetailPersonalInfoVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/23/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class DetailPersonalInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cellIdentifier: String! = "personalInfoDetailDataCell"
    var cellHirarkiidentifier: String! = "personalInfoDetailHirarkiCell"
    var headerView: PersonalInfoDetailHeader!
    weak var personalInfoListDetailDelegate: PersonalInfoVC!
    var stringNpp: String! = ""
    var stringNppAtasan: String! = ""
    var personalInfoDetail: Array<AnyObject>! = []
    var personalInfoAtasan: Array<AnyObject>! = []
    var personalInfoPeer: Array<AnyObject>! = []
    var personalInfoBawahan: Array<AnyObject>! = []
    var stringInfo: String! = ""
    var stringKantor: String! = ""
    var stringAgama: String! = ""
    var stringTtl: String! = ""
    var stringAlamat: String! = ""
    var stringTelp: String! = ""
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    @IBOutlet weak var tblDetailPersonalInfo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(DetailPersonalInfoVC.dismissDetailPersonalInfo(_:)))
        self.view.addGestureRecognizer(gesture)
        
        self.tblDetailPersonalInfo.registerNib(UINib(nibName: "PersonalInfoDetailDataCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tblDetailPersonalInfo.registerNib(UINib(nibName: "PersonalInfoDetailHirarkiCell", bundle: nil), forCellReuseIdentifier: cellHirarkiidentifier)
        self.tblDetailPersonalInfo.delegate = self
        self.tblDetailPersonalInfo.dataSource = self
        
//        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
        self.automaticallyAdjustsScrollViewInsets = false
        self.getDetailPersonalInfoData()
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SelfServiceUtility.setupRatioWidthBasedOnLandscape() : SelfServiceUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SelfServiceUtility.setupRatioHeightBasedOnLandscape() : SelfServiceUtility.setupRatioHeightBasedOnDeviceScreen()
        
        self.tblDetailPersonalInfo.frame = SelfServiceUtility.setupViewWidthAndHeightBasedOnRatio(self.tblDetailPersonalInfo.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.3, animations: { [weak self] in
            self!.view.frame = CGRect(x: 6, y: 26, width: (self?.view.frame.width)! - 12, height: (self?.view.frame.height)! - 12)
            self!.view.layer.cornerRadius = 5.0
            self!.view.layer.borderWidth = 1.5
            self!.view.layer.borderColor = SelfServiceUtility.colorWithHexString("FFA726").CGColor
            self!.view.layer.masksToBounds = true
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDetailPersonalInfoData() {
        SelfServiceUtility.showLoadingView((self.parentViewController?.parentViewController?.view)!)
        let params = ["npp" : self.stringNpp,
                      "api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!,
                      "nppreq" : self.stringNppAtasan
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_PERSONAL_INFO_ATASAN, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.personalInfoDetail = JSON["data"] as? Array<AnyObject>
                    let gender = (self.personalInfoDetail[0]["SEX"] as! String == "M") ? "Laki-laki" : "Perempuan"
                    let stringDates = String(format: "%@", self.personalInfoDetail[0]["DATE_OF_BIRTH"] as! String)
                    var stringDatesArr = stringDates.characters.split{$0 == " "}.map(String.init)
                    var stringDatesArr1 = stringDatesArr[0].characters.split{$0 == "-"}.map(String.init)
                    let tglLahir: String = String(format: "%@/%@/%@", stringDatesArr1[1], stringDatesArr1[0], stringDatesArr1[2])
                    self.stringInfo = String(format: "%@, %@", self.personalInfoDetail[0]["EMPLOYMENT_CATEGORY"] as! String, self.personalInfoDetail[0]["UNIT_KERJA"] as! String)
                    self.stringKantor = String(format: "%@", self.personalInfoDetail[0]["LOCATION_ADDRESS"] as! String)
                    self.stringAgama = String(format: "%@, %@", self.personalInfoDetail[0]["AGAMA"] as! String, gender)
                    self.stringTtl = String(format: "%@, %@", self.personalInfoDetail[0]["TOWN_OF_BIRTH"] as! String, tglLahir)
                    self.stringAlamat = String(format: "%@", self.personalInfoDetail[0]["ALAMAT"] as! String)
                    self.stringTelp = (self.personalInfoDetail[0]["TEL_NUMBER_1"] == nil) ? String(format: "%@", (self.personalInfoDetail[0]["TEL_NUMBER_1"] as? String)!) : "-"
                    
                    self.setupPersonalInfoDetailHeader(self.personalInfoDetail)
                    if (self.personalInfoDetail[0]["PARENT_ASSIGNMENT_NUMBER"] is NSNull) {
                        self.personalInfoAtasan = []
                        self.personalInfoPeer = []
                        self.getDetailPersonalInfoBawahan((self.personalInfoDetail[0]["ASSIGNMENT_NUMBER"] as? String)!)
                    }else{
                        self.getDetailPersonalInfoAtasan((self.personalInfoDetail[0]["PARENT_ASSIGNMENT_NUMBER"] as? String)!)
                    }
                    
                }
        }
    }
    
    func getDetailPersonalInfoAtasan(stringNppAtasan: String) {
        let params = ["npp" : self.stringNpp,
                      "api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!,
                      "nppreq" : stringNppAtasan
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_PERSONAL_INFO_ATASAN, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.personalInfoAtasan = JSON["data"] as? Array<AnyObject>
                    self.getDetailPersonalInfoPeer((self.personalInfoDetail[0]["PARENT_ASSIGNMENT_NUMBER"] as? String)!)
                }
        }
    }
    
    func getDetailPersonalInfoPeer(stringNppPeer: String) {
        let params = ["npp" : self.stringNpp,
                      "api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!,
                      "nppreq" : stringNppPeer
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_PERSONAL_INFO_PEER, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.personalInfoPeer = JSON["data"] as? Array<AnyObject>
                    self.getDetailPersonalInfoBawahan((self.personalInfoDetail[0]["ASSIGNMENT_NUMBER"] as? String)!)
                }
        }
    }
    
    func getDetailPersonalInfoBawahan(stringNppBawahan: String) {
        let params = ["npp" : self.stringNpp,
                      "api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!,
                      "nppreq" : stringNppBawahan
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_PERSONAL_INFO_BAWAHAN, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.personalInfoBawahan = JSON["data"] as? Array<AnyObject>
                    print("stringNpp " ,(self.personalInfoDetail[0]["ASSIGNMENT_NUMBER"] as? String)!)
                    for (index, element) in self.personalInfoPeer.enumerate() {
                        if ((element["ASSIGNMENT_NUMBER"] as? String)! == (self.personalInfoDetail[0]["ASSIGNMENT_NUMBER"] as? String)!) {
                            print("stringNpp " ,(element["ASSIGNMENT_NUMBER"] as? String)!)
                            self.personalInfoPeer.removeAtIndex(index)
                        }
                    }
                    self.tblDetailPersonalInfo.reloadData()
                    SelfServiceUtility.hideLoadingView((self.parentViewController?.parentViewController?.view)!)
                }
        }
    }
    
    func setupPersonalInfoDetailHeader(personalInfoDetail: Array<AnyObject>) {
        if (headerView != nil) {
            headerView.removeFromSuperview()
            headerView = nil
        }
        let className = String(PersonalInfoDetailHeader.self)
        let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        headerView = nibViews!.first as? PersonalInfoDetailHeader
        headerView.personalInfoDetailHeaderDelegate = self
        headerView.personalInfoDetail = personalInfoDetail
        headerView.setupPersonalInfoDetailView()
        self.tblDetailPersonalInfo.addSubview(headerView)
    }
    
    func dismissDetailPersonalInfo(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocityInView(self.view)
        if (velocity.y >= 0) {
            UIView.animateWithDuration(0.3, animations: { [weak self] in
                let frame = self?.view.frame
                let yComponent = UIScreen.mainScreen().bounds.height
                self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
                })
        }
        
    }
    
    /*
     // MARK - UITableView Delegate Method
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let className = String(PersonalInfoDetailDataCell.self)
            let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
            
            let cell = nibViews!.first as! PersonalInfoDetailDataCell
            
            cell.vInfoDetail.text = stringInfo
            cell.vKantorDetail.text = stringKantor
            cell.vAgamaDetail.text = stringAgama
            cell.vTtlDetail.text = stringTtl
            cell.vAlamatDetail.text = stringAlamat
            cell.vTelpDetail.text = stringTelp
            
            return cell
        }else{
            let className = String(PersonalInfoDetailHirarkiCell.self)
            let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
            
            let cell = nibViews!.first as! PersonalInfoDetailHirarkiCell
        
//            if (self.personalInfoPeer.count > 0) {
//            }

            if (cell.hirarkiView != nil) {
                cell.hirarkiView.removeFromParentViewController()
                cell.hirarkiView.view.removeFromSuperview()
                cell.hirarkiView = nil
            }
            let itemNpp = (self.personalInfoDetail.count > 0) ? String(format: "%@", (self.personalInfoDetail[0]["ASSIGNMENT_NUMBER"] as? String)!) : ""
            let urlFoto = (self.personalInfoDetail.count > 0) ? String(format: "%@%@", ConstantAPI.URL_IMAGE, (self.personalInfoDetail[0]["urlfoto"] as? String)!) : ""
            let urlFotoAtasan = (self.personalInfoAtasan.count > 0) ? String(format: "%@%@", ConstantAPI.URL_IMAGE, (self.personalInfoAtasan[0]["urlfoto"] as? String)!) : ""
            let itemNamaAtasan = (self.personalInfoAtasan.count > 0) ? String(format: "%@", (self.personalInfoAtasan[0]["LAST_NAME"] as? String)!) : ""
            let itemNppAtasan = (self.personalInfoAtasan.count > 0) ? String(format: "%@", (self.personalInfoAtasan[0]["ASSIGNMENT_NUMBER"] as? String)!) : ""
            
            cell.setupPersonalInfoDetailHirarki(itemNpp, itemRekan: self.personalInfoPeer, delegate: self, itemNppAtasan: itemNppAtasan, itemNamaAtasan: itemNamaAtasan, itemUrl: urlFoto, itemUrlAtasan: urlFotoAtasan, itemBawahan: self.personalInfoBawahan)
            
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath.row == 0) ? 357.0 : 400.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath.row == 0) ? UITableViewAutomaticDimension : ((ratioHeight <= 0.56) ? 260.0 : (ratioHeight > 0.56 && ratioHeight <= 0.65) ? 315.0 : (ratioHeight > 0.65 && ratioHeight <= 0.72) ? 354.0 : 400.0)
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
