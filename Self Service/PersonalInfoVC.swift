//
//  PersonalInfoVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/19/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore

class PersonalInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let personalInfoCellIdentifier = "personalInfoCell"
    var personalInfoItems: Array<AnyObject>! = []
    var isLoadMore: Bool = false
    var isMaxSize: Bool = false
    var prevSize: Int = 0
    var searchWord: String! = ""
    var personalInfoBottomSheet: PersonalInfoSheetVC!
    var detailPersonalInfo: DetailPersonalInfoVC!
    @IBOutlet weak var lblHeaderPersonalInfo: UILabel!
    @IBOutlet weak var tblPersonalInfo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        self.tblPersonalInfo.registerNib(UINib(nibName: "PersonalInfoCell", bundle: nil), forCellReuseIdentifier: personalInfoCellIdentifier)
        self.tblPersonalInfo.delegate = self
        self.tblPersonalInfo.dataSource = self
        self.tblPersonalInfo.tableFooterView = UIView(frame: CGRectZero)
        
        self.lblHeaderPersonalInfo.font = self.lblHeaderPersonalInfo.font.fontWithSize(SelfServiceUtility.setupPersonalInfoHeaderFontSize())
        
        self.searchWord = ""
        
        self.getPersonalInfoData(self.searchWord, start: 0, limit: 20)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupPersonalInfoBottomSheetView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPersonalInfoData(kword: String, start: Int, limit: Int) {
        SelfServiceUtility.showLoadingView((self.parentViewController?.view)!)
        let params = ["api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!,
                      "npp" : (GlobalVariable.sharedInstance.itemLogin[0]["npp"] as? String)!,
                      "word" : kword,
                      "start" : String(format: "%d", start),
                      "limit" : String(format: "%d", limit)
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_PERSONAL_INFO, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    SelfServiceUtility.hideLoadingView((self.parentViewController?.view)!)
                    self.personalInfoItems = (JSON["data"] as? Array<AnyObject>)!
                    print(self.personalInfoItems.description)
                    self.tblPersonalInfo.reloadData()
                }
        }
    }
    
    func getMorePersonalInfoData(kword: String, start: Int, limit: Int) {
        SelfServiceUtility.showLoadingView((self.parentViewController?.view)!)
        let params = ["api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!,
                      "npp" : (GlobalVariable.sharedInstance.itemLogin[0]["npp"] as? String)!,
                      "word" : kword,
                      "start" : String(format: "%d", start),
                      "limit" : String(format: "%d", limit)
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_PERSONAL_INFO, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    let tempArray = JSON["data"] as? NSArray
                    UIView.transitionWithView(self.tblPersonalInfo, duration: 0.500, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        if (tempArray!.count > 0) {
                            for i in 0 ..< tempArray!.count  {
                                self.personalInfoItems.append(tempArray![i])
                            }
                        }
                        }, completion: { (finished: Bool) -> () in
                            print(self.personalInfoItems.count)
                            if (self.prevSize != self.personalInfoItems.count) {
                                self.prevSize = self.personalInfoItems.count
                            }else{
                                self.isMaxSize = true
                            }
                            self.tblPersonalInfo.reloadData()
                            self.isLoadMore = false
                            SelfServiceUtility.hideLoadingView((self.parentViewController?.view)!)
                    })
                }
        }
    }
    
    func setupPersonalInfoBottomSheetView() {
        self.personalInfoBottomSheet = PersonalInfoSheetVC(nibName: "PersonalInfoSheetVC", bundle: nil)
        self.personalInfoBottomSheet.personalInfoSheetDelegate = self
        self.addChildViewController(self.personalInfoBottomSheet)
        self.view.addSubview(self.personalInfoBottomSheet.view)
        self.view.bringSubviewToFront(self.personalInfoBottomSheet.view)
        self.personalInfoBottomSheet.didMoveToParentViewController(self)
        self.personalInfoBottomSheet.view.frame = CGRectMake(0, self.view.frame.maxY, self.view.frame.size.width, 68)
    }
    
    func showDetailPersonalInfoView(stringNpp: String, stringNppAtasan: String) {
        if (self.detailPersonalInfo != nil) {
            self.detailPersonalInfo.view.removeFromSuperview()
            self.detailPersonalInfo.removeFromParentViewController()
            self.detailPersonalInfo = nil
        }
        self.detailPersonalInfo = DetailPersonalInfoVC(nibName: "DetailPersonalInfoVC", bundle: nil)
        self.detailPersonalInfo.personalInfoListDetailDelegate = self
        self.detailPersonalInfo.stringNpp = stringNpp
        self.detailPersonalInfo.stringNppAtasan = stringNppAtasan
        self.parentViewController?.addChildViewController(self.detailPersonalInfo)
        self.parentViewController?.view.addSubview(self.detailPersonalInfo.view)
        self.parentViewController?.view.bringSubviewToFront(self.detailPersonalInfo.view)
        self.detailPersonalInfo.didMoveToParentViewController(self.parentViewController)
        self.detailPersonalInfo.view.frame = CGRectMake(0, self.view.frame.maxY, self.view.frame.size.width, self.view.frame.size.height)
    }
    
    func loadPersonalInfoPict(imageIcon: UIImageView, urlString: String) {
        
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                let tempImage = UIImage(data: response.data!)
                imageIcon.image = SelfServiceUtility.cropImageToWidth(tempImage!, width: (tempImage?.size.width)!, height: (tempImage?.size.width)!)
        }
    }
    
    func movedPersonalInfoViewUp(movedUp: Bool) {
        print(self.view)
        SelfServiceUtility.movedViewUp(movedUp, view: self.view, pos: 216.0)
    }
    
    /*
    // MARK - UITABLEVIEW DELEGATE
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personalInfoItems.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == self.personalInfoItems.count - 1) {
            print(self.isMaxSize)
            print(self.isLoadMore)
            if (self.isLoadMore == false && self.isMaxSize == false) {
                self.isLoadMore = true
                self.getMorePersonalInfoData(self.searchWord, start: self.personalInfoItems.count, limit: 20)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let className = String(PersonalInfoCell.self)
        let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        
        let cell = nibViews!.first as! PersonalInfoCell
        if (self.personalInfoItems.count > 0) {
            let urlImage: String = ConstantAPI.URL_IMAGE + (self.personalInfoItems[indexPath.row]["urlfoto"] as? String)!
            self.loadPersonalInfoPict(cell.ivProfil, urlString: urlImage)
            cell.lblNamaPersonalInfo.text = self.personalInfoItems[indexPath.row]["LAST_NAME"] as? String
            cell.lblJabatanPersonalInfo.text = self.personalInfoItems[indexPath.row]["POSITION_NAME"] as? String
            
            cell.ivProfil.layer.cornerRadius = 10.0
            cell.ivProfil.layer.masksToBounds = true
        }

        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print((GlobalVariable.sharedInstance.itemLogin[0]["ASSIGNMENT_NUMBER"] as? String)!)
        print((self.personalInfoItems[indexPath.row]["ASSIGNMENT_NUMBER"] as? String)!)
        self.showDetailPersonalInfoView((GlobalVariable.sharedInstance.itemLogin[0]["ASSIGNMENT_NUMBER"] as? String)!, stringNppAtasan: (self.personalInfoItems[indexPath.row]["ASSIGNMENT_NUMBER"] as? String)!)
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
