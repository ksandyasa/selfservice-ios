//
//  PersonalInfoDetailHirarkiViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/4/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class PersonalInfoDetailHirarkiViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var personalPict: UIImageView!
    @IBOutlet weak var personalAtasanPict: UIImageView!
    @IBOutlet weak var personalNamaAtasan: UILabel!
    @IBOutlet weak var personalBawahan: UICollectionView!
    @IBOutlet weak var personalRekan: UICollectionView!
    let cellIdentifierRekan: String! = "personalInfoRekanCell"
    let cellIdentifierBawahan: String! = "personalInfoBawahanCell"
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var infoDetailNpp: String! = ""
    var infoDetailNppAtasan: String! = ""
    var infoDetailNamaAtasan: String! = ""
    var infoDetailUrlAtasan: String! = ""
    var infoDetailUrl: String = ""
    var infoDetailRekan: Array<AnyObject>! = []
    var infoDetailBawahan: Array<AnyObject>! = []
    weak var personalInfoDetailDelegate: DetailPersonalInfoVC!
    @IBOutlet weak var personalAtasanPictWidth: NSLayoutConstraint!
    @IBOutlet weak var personalAtasanPictHeight: NSLayoutConstraint!
    @IBOutlet weak var personalPictWidth: NSLayoutConstraint!
    @IBOutlet weak var personalPictHeight: NSLayoutConstraint!
    @IBOutlet weak var personalBawahanHeight: NSLayoutConstraint!
    @IBOutlet weak var personalRekanWidth: NSLayoutConstraint!
    @IBOutlet weak var personalRekanHeight: NSLayoutConstraint!
    @IBOutlet weak var personalInfoRekanLine: UILabel!
    @IBOutlet weak var personalInfoAtasanLine: UILabel!
    @IBOutlet weak var personalInfoBawahanLine: UILabel!
    @IBOutlet weak var personalInfoBawahanWidth: NSLayoutConstraint!
    @IBOutlet weak var personalInfoRekanLeft: NSLayoutConstraint!
    @IBOutlet weak var personalInfoBawahanBottom: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        personalRekan.registerNib(UINib(nibName: "PersonalInfoRekanCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifierRekan)
        personalBawahan.registerNib(UINib(nibName: "PersonalInfoBawahanCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifierBawahan)
        
        personalRekan.delegate = self
        personalRekan.dataSource = self
        
        personalBawahan.delegate = self
        personalBawahan.dataSource = self
        personalBawahan.contentInset = UIEdgeInsets(top: 1.25, left: 1.25, bottom: 1.25, right: 1.25)
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SelfServiceUtility.setupRatioWidthBasedOnLandscape() : SelfServiceUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SelfServiceUtility.setupRatioHeightBasedOnLandscape() : SelfServiceUtility.setupRatioHeightBasedOnDeviceScreen()
                
        print("%@", self.view.frame.size.height)
        
        personalRekan.frame = SelfServiceUtility.setupViewWidthAndHeightBasedOnRatio(personalRekan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        if (ratioWidth < 1) {
            personalInfoRekanLeft.constant = 8.0
        }
        personalBawahan.frame = SelfServiceUtility.setupViewWidthAndHeightBasedOnRatio(personalBawahan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        personalInfoBawahanWidth.constant = (ratioWidth <= 0.42) ? personalInfoBawahanWidth.constant - 160 : (ratioWidth > 0.42 && ratioWidth <= 0.48) ? personalInfoBawahanWidth.constant - 120 : (ratioWidth > 0.48 && ratioWidth <= 0.54) ? personalInfoBawahanWidth.constant - 80 : personalInfoBawahanWidth.constant
        personalInfoBawahanBottom.constant = 8.0
        
        personalRekanHeight.constant = ratioHeight * personalRekanHeight.constant
        
        personalAtasanPictHeight.constant = (ratioHeight <= 0.56) ? personalAtasanPictHeight.constant - 24 : (ratioHeight > 0.56 && ratioHeight <= 0.65) ? personalAtasanPictHeight.constant - 16 : (ratioHeight > 0.65 && ratioHeight <= 0.72) ? personalAtasanPictHeight.constant - 8 : personalAtasanPictHeight.constant
        personalAtasanPictWidth.constant = personalAtasanPictHeight.constant
        //let cornerRadiusAtasan = personalAtasanPictHeight.constant
        personalAtasanPict.layer.cornerRadius = 10.0
        personalAtasanPict.layer.masksToBounds = true
        
        personalPictHeight.constant = (ratioHeight <= 0.56) ? personalPictHeight.constant - 24 : (ratioHeight > 0.56 && ratioHeight <= 0.65) ? personalPictHeight.constant - 16 : (ratioHeight > 0.65 && ratioHeight <= 0.72) ? personalPictHeight.constant - 8 : personalPictHeight.constant
        personalPictWidth.constant = personalPictHeight.constant
        //let cornerRadius = personalPictHeight.constant
        personalPict.layer.cornerRadius = 10.0
        personalPict.layer.masksToBounds = true
        
        personalNamaAtasan.lineBreakMode = NSLineBreakMode.ByWordWrapping
        personalNamaAtasan.numberOfLines = 0
        personalNamaAtasan.font = personalNamaAtasan.font.fontWithSize(SelfServiceUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        personalNamaAtasan.sizeToFit()
        personalNamaAtasan.frame = SelfServiceUtility.setupViewWidthAndHeightBasedOnRatio(personalNamaAtasan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        //setupInfoDetailBawahanItems()
        print(self.infoDetailRekan.description)
        print(self.infoDetailBawahan.description)
        self.setupInfoDetailItems()
        if (self.infoDetailRekan.count > 0) {
            self.personalRekan.reloadData()
        }else{
            self.personalInfoRekanLine.hidden = true
        }
        if (self.infoDetailBawahan.count > 0) {
            self.personalBawahan.reloadData()
        }else{
            self.personalInfoBawahanLine.hidden = true
        }
    }
    
    func setupInfoDetailBawahanItems() {
        let params = ["npp" : String(format: "%@", infoDetailNpp),
                      "api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!
        ]
        
        Alamofire.request(.GET, ConstantAPI.API_POST_PERSONAL_INFO_BAWAHAN, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.infoDetailBawahan = JSON["data"] as? Array<AnyObject>
                    UIView.transitionWithView(self.personalBawahan, duration: 0.325, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        self.setupInfoDetailItems()
                        if (self.infoDetailBawahan.count > 0) {
                            self.personalBawahan.reloadData()
                        }else{
                            self.personalInfoBawahanLine.hidden = true
                        }
                        }, completion: { (finished: Bool) -> () in
                            if (self.infoDetailRekan.count > 0) {
                                self.personalRekan.reloadData()
                            }else{
                                self.personalInfoRekanLine.hidden = true
                            }
                    })
                }
        }
    }
    
    func setupPersonalInfoIcons(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                let tempImage = UIImage(data: response.data!)
                if (tempImage != nil) {
                    imageIcon.image = SelfServiceUtility.cropImageToWidth(tempImage!, width: (tempImage?.size.width)!, height: (tempImage?.size.width)!)
                }
        }
    }
    
    func setupInfoDetailItems() {
        self.setupPersonalInfoIcons(personalPict, urlString: infoDetailUrl)
        if (infoDetailUrlAtasan != "") {
            self.setupPersonalInfoIcons(personalAtasanPict, urlString: infoDetailUrlAtasan)
        }else{
            personalAtasanPict.hidden = true
            personalInfoAtasanLine.hidden = true
        }
        print(infoDetailNamaAtasan)
        personalNamaAtasan.text = infoDetailNamaAtasan
        let tapAtasan = UITapGestureRecognizer(target: self, action: #selector(PersonalInfoDetailHirarkiViewController.actionFromAtasanPictClick(_:)))
        personalAtasanPict.addGestureRecognizer(tapAtasan)
    }
    
    func actionFromAtasanPictClick(sender: UITapGestureRecognizer) {
        print("Action Clicked")
        personalInfoDetailDelegate.stringNppAtasan = infoDetailNppAtasan
        personalInfoDetailDelegate.getDetailPersonalInfoData()
    }
    
    /*
    // MARK - UICollectionView Delegate
    */
    
    // UICollection View Delegate Method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == self.personalRekan) ? infoDetailRekan.count : infoDetailBawahan.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if (collectionView == self.personalRekan) {
            let itemCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifierRekan, forIndexPath: indexPath) as! PersonalInfoRekanCell
            
            if (infoDetailRekan.count > 0) {
                var urlRekan: String = ""
                if (self.infoDetailRekan[indexPath.row]["urlfoto"] is NSNull) {
                    urlRekan = ""
                }else{
                    urlRekan = String(format: "%@%@", ConstantAPI.URL_IMAGE, (self.infoDetailRekan[indexPath.row]["urlfoto"] as? String)!)
                }
                
                self.setupPersonalInfoIcons(itemCell.personalInfoRekanPict, urlString: urlRekan)
            }
            
            return itemCell
        }else{
            let itemCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifierBawahan, forIndexPath: indexPath) as! PersonalInfoBawahanCell
            
            if (infoDetailBawahan.count > 0) {
                var urlBawahan: String = ""
                if (self.infoDetailBawahan[indexPath.row]["urlfoto"] is NSNull) {
                    urlBawahan = ""
                }else{
                    urlBawahan = String(format: "%@%@", ConstantAPI.URL_IMAGE, (self.infoDetailBawahan[indexPath.row]["urlfoto"] as? String)!)
                }
                
                self.setupPersonalInfoIcons(itemCell.personalInfoBawahanPict, urlString: urlBawahan)
                itemCell.personalInfoBawahanName.text = (self.infoDetailBawahan[indexPath.row]["LAST_NAME"] as? String)!
            }
            
            return itemCell

        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return (collectionView == self.personalRekan) ? CGSizeMake(ratioWidth * 72, ratioHeight * 72) : CGSizeMake(ratioWidth * 100, ratioHeight * 85)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var nppPersonal: String = ""
        if (collectionView == self.personalRekan) {
            nppPersonal = (infoDetailRekan[indexPath.row]["ASSIGNMENT_NUMBER"] as? String)!
        }else{
            nppPersonal = (infoDetailBawahan[indexPath.row]["ASSIGNMENT_NUMBER"] as? String)!
        }
        personalInfoDetailDelegate.stringNppAtasan = nppPersonal
        personalInfoDetailDelegate.getDetailPersonalInfoData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
