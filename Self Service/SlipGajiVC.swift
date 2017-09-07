//
//  SlipGajiVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/4/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class SlipGajiVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate, IGCMenuDelegate {

    let slipGajiCellIdentifier = "profilCell"
    var rincianPenerimaan: Array<AnyObject>! = []
    var rincianPotongan: Array<AnyObject>! = []
    var period: Array<AnyObject>! = []
    var santunanDuka: Array<AnyObject>! = []
    var totPenerimaan: Int64 = 0
    var totPotongan: Int64 = 0
    var gajiBersih: Int64 = 0
    var periodItem: String! = ""
    var periodAlertController: UIAlertController!
    var periodPicker: UIPickerView!
    var bottonSheet: SlipGajiSheetVC!
    var menuSlipGaji: IGCMenu!
    var rincianGaji: RincianGajiVC!
    var isMenuActive: Bool = false
    @IBOutlet weak var lblHeaderSlipGaji: UILabel!
    @IBOutlet weak var lblNppNama: UILabel!
    @IBOutlet weak var lblPayroll: UILabel!
    @IBOutlet weak var txtPeriod: UITextField!
    @IBOutlet weak var tblInfoSlipGaji: UITableView!
    @IBOutlet weak var btnMenuSlipGaji: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.txtPeriod.delegate = self
        
        self.tblInfoSlipGaji.registerNib(UINib(nibName: "ProfilCell", bundle: nil), forCellReuseIdentifier: slipGajiCellIdentifier)
        self.tblInfoSlipGaji.delegate = self
        self.tblInfoSlipGaji.dataSource = self
        self.tblInfoSlipGaji.tableFooterView = UIView(frame: CGRectZero)
        self.tblInfoSlipGaji.layer.borderWidth = 2.0
        self.tblInfoSlipGaji.layer.borderColor = SelfServiceUtility.colorWithHexString("FFA726").CGColor
        self.tblInfoSlipGaji.layer.masksToBounds = true
        
        self.lblHeaderSlipGaji.font = self.lblHeaderSlipGaji.font.fontWithSize(SelfServiceUtility.setupFontSizeBasedByScreenHeight())
        
        let shadowTableView: UIView = UIView(frame: self.tblInfoSlipGaji.frame)
        shadowTableView.backgroundColor = UIColor.clearColor()
        shadowTableView.layer.shadowColor = SelfServiceUtility.colorWithHexString("787878").CGColor
        shadowTableView.layer.shadowOffset = CGSizeMake(5, 10)
        shadowTableView.layer.shadowOpacity = 0.3
        shadowTableView.layer.shadowRadius = 2
        self.view.addSubview(shadowTableView)
        shadowTableView.addSubview(self.tblInfoSlipGaji)
        
        print(GlobalVariable.sharedInstance.itemLogin[0])
        
        self.lblNppNama.text = (GlobalVariable.sharedInstance.itemLogin[0]["ASSIGNMENT_NUMBER"] as? String)! + ", " + (GlobalVariable.sharedInstance.itemLogin[0]["LAST_NAME"] as? String)!
        self.lblPayroll.text = "Payroll Group JM Kantor " + (GlobalVariable.sharedInstance.itemLogin[0]["LOCATION_NAME"] as? String)!
        
        self.setupSlipGajiMenuView()
        self.setupPeriodView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupBottonSheetView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPeriodView() {
        SelfServiceUtility.showLoadingView(self.parentViewController!.view)
        let params = ["api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!, "npp" : (GlobalVariable.sharedInstance.itemLogin[0]["npp"] as? String)!
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_PERIOD, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    let code: Int = (JSON["code"] as? Int)!
                    if (code == 400) {
                        
                    }else{
                        self.period = (JSON["data"] as? Array<AnyObject>)!
                        //print(self.period.description)
                        self.periodItem = (self.period[self.period.count-1]["name"] as? String)!
                        self.txtPeriod.text = (self.period[self.period.count-1]["name"] as? String)!
                        self.setupRincianPenerimaanView()
                    }
                }
        }
    }
    
    func setupRincianPenerimaanView() {
        let params = ["api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!, "npp" : (GlobalVariable.sharedInstance.itemLogin[0]["npp"] as? String)!, "period" : self.periodItem
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_RINCIAN_PENERIMAAN, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.rincianPenerimaan = (JSON["data"] as? Array<AnyObject>)!
                    for (index, element) in self.rincianPenerimaan.enumerate() {
                        //print(index, ":", element)
                        if (element["value_penerimaan"] is NSNull) {
                            self.totPenerimaan = self.totPenerimaan + 0
                        }else{
                            self.totPenerimaan = self.totPenerimaan + (element["value_penerimaan"] as? Int)!
                        }
                    }
                    print(self.totPenerimaan)
                    self.setupRincianPotonganView()
                }
        }
    }
    
    func setupRincianPotonganView() {
        let params = ["api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!, "npp" : (GlobalVariable.sharedInstance.itemLogin[0]["npp"] as? String)!, "period" : self.periodItem
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_RINCIAN_POTONGAN, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.rincianPotongan = (JSON["data"] as? Array<AnyObject>)!
                    for (index, element) in self.rincianPotongan.enumerate() {
                        //print(index, ":", element)
                        self.totPotongan = self.totPotongan + (element["value_potongan"] as? Int)!
                    }
                    self.gajiBersih = self.totPenerimaan - self.totPotongan
                    self.setupSantunanDuka()
                }
        }
    }
    
    func setupSantunanDuka() {
        let params = ["api_token" : (NSUserDefaults.standardUserDefaults().objectForKey("apiTokenPrefs") as? String)!, "npp" : (GlobalVariable.sharedInstance.itemLogin[0]["npp"] as? String)!, "period" : self.periodItem
        ]
        
        Alamofire.request(.POST, ConstantAPI.API_POST_SANTUNAN_DUKA, parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.santunanDuka = (JSON["data"] as? Array<AnyObject>)!
                    print(self.santunanDuka)
                    SelfServiceUtility.hideLoadingView(self.parentViewController!.view)
                    self.setupSlipGajiView()
                }
        }
    }
    
    func setupSlipGajiView() {
        self.tblInfoSlipGaji.reloadData()
    }
    
    func setupPeriodPickerView() {
        self.periodAlertController = UIAlertController(title: "Pilih Cabang",
                                                  message: "\n\n\n\n\n\n\n\n\n",
                                                  preferredStyle: .ActionSheet)
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            self.periodAlertController.modalPresentationStyle = .Popover
            self.periodAlertController.popoverPresentationController!.sourceView = self.txtPeriod
            self.periodAlertController.popoverPresentationController!.sourceRect = self.txtPeriod.bounds
        }
        
        let tutupAction = UIAlertAction(title: "Tutup", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in print("tutup")})
        self.periodAlertController.addAction(tutupAction)
        
        self.periodPicker = UIPickerView()
        self.periodPicker.delegate = self
        self.periodPicker.dataSource = self
        self.periodPicker.showsSelectionIndicator = true
        self.periodPicker.reloadAllComponents()
        self.periodPicker.bounds = CGRectMake(-10, self.periodPicker.bounds.origin.y, self.periodPicker.bounds.size.width, self.periodPicker.bounds.size.height)

        self.periodAlertController.view.addSubview(self.periodPicker)
        
        self.presentViewController(self.periodAlertController, animated: true, completion: nil)
        
    }
    
    func setupBottonSheetView() {
        self.bottonSheet = SlipGajiSheetVC(nibName: "SlipGajiSheetVC", bundle: nil)
        self.bottonSheet.slipGajiSheetDelegate = self
        self.addChildViewController(self.bottonSheet)
        self.view.addSubview(self.bottonSheet.view)
        self.view.bringSubviewToFront(self.bottonSheet.view)
        self.bottonSheet.didMoveToParentViewController(self)
        self.bottonSheet.view.frame = CGRectMake(0, self.view.frame.maxY, self.view.frame.size.width, 114)
    }
    
    func setupSlipGajiMenuView() {
        self.btnMenuSlipGaji.layer.cornerRadius = self.btnMenuSlipGaji.frame.size.width / 2
        self.btnMenuSlipGaji.clipsToBounds = true
        
        if (self.menuSlipGaji == nil) {
            self.menuSlipGaji = IGCMenu()
        }
        self.menuSlipGaji.menuButton = self.btnMenuSlipGaji
        self.menuSlipGaji.menuSuperView = self.view
        self.menuSlipGaji.numberOfMenuItem = 2
        
        self.menuSlipGaji.menuItemsNameArray = ["Rincian Penerimaan", "Rincian Potongan"]
        self.menuSlipGaji.menuImagesNameArray = ["icon_rincian_gaji.png", "icon_rincian_potongan.png"]
        self.menuSlipGaji.delegate = self
    }
    
    func showRincianPenerimaanViews() {
        print("Rincian Penerimaan")
        if (self.rincianGaji != nil) {
            self.rincianGaji.view.removeFromSuperview()
            self.rincianGaji.removeFromParentViewController()
            self.rincianGaji = nil
        }
        
        self.rincianGaji = RincianGajiVC(nibName: "RincianGajiVC", bundle: nil)
        self.rincianGaji.rincianGajiDelegate = self
        self.rincianGaji.rincianMode = 0
        self.rincianGaji.rincianItems = self.rincianPenerimaan
        self.rincianGaji.totalGaji = self.totPenerimaan
        self.rincianGaji.totalPotongan = self.totPotongan
        self.rincianGaji.penerimaanBersih = self.gajiBersih
        self.rincianGaji.santunanDuka = self.santunanDuka
        self.parentViewController?.addChildViewController(self.rincianGaji)
        self.parentViewController?.view.addSubview(self.rincianGaji.view)
        self.parentViewController?.view.bringSubviewToFront(self.rincianGaji.view)
        self.rincianGaji.didMoveToParentViewController(self.parentViewController)
        self.rincianGaji.view.frame = CGRectMake(0, self.view.frame.maxY, self.view.frame.size.width, self.view.frame.size.height)
    }
    
    func showRincianPotonganViews() {
        print("Rincian Potongan")
        if (self.rincianGaji != nil) {
            self.rincianGaji.view.removeFromSuperview()
            self.rincianGaji.removeFromParentViewController()
            self.rincianGaji = nil
        }
        
        self.rincianGaji = RincianGajiVC(nibName: "RincianGajiVC", bundle: nil)
        self.rincianGaji.rincianGajiDelegate = self
        self.rincianGaji.rincianMode = 1
        self.rincianGaji.rincianItems = self.rincianPotongan
        self.rincianGaji.totalGaji = self.totPenerimaan
        self.rincianGaji.totalPotongan = self.totPotongan
        self.rincianGaji.penerimaanBersih = self.gajiBersih
        self.rincianGaji.santunanDuka = self.santunanDuka
        self.parentViewController?.addChildViewController(self.rincianGaji)
        self.parentViewController?.view.addSubview(self.rincianGaji.view)
        self.parentViewController?.view.bringSubviewToFront(self.rincianGaji.view)
        self.rincianGaji.didMoveToParentViewController(self.parentViewController)
        self.rincianGaji.view.frame = CGRectMake(0, self.view.frame.maxY, self.view.frame.size.width, self.view.frame.size.height)
    }
    
    @IBAction func showSlipGajiMenu(sender: UIButton) {
        if (isMenuActive) {
            isMenuActive = false
            self.menuSlipGaji.hideCircularMenu()
        }else{
            isMenuActive = true
            self.menuSlipGaji.showCircularMenu()
        }
    }
    
    @IBAction func showPeriod(sender: UIButton) {
        self.setupPeriodPickerView()
    }
    
    /*
     // MARK - UITABLEVIEW DELEGATE
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tblInfoSlipGaji.dequeueReusableCellWithIdentifier(slipGajiCellIdentifier) as! ProfilCell
        
        if (indexPath.row == 0) {
            cell.lblTitleProfil.text = "Total Gaji"
            cell.lblDescProfil.text = "Rp. " + String(format: "%@", SelfServiceUtility.setSeparateCurrency(Float(totPenerimaan)))
        }else if (indexPath.row == 1) {
            cell.lblTitleProfil.text = "Total Potongan"
            cell.lblDescProfil.text = "Rp. " + String(format: "%@", SelfServiceUtility.setSeparateCurrency(Float(totPotongan)))
        }else if (indexPath.row == 2) {
            cell.lblTitleProfil.text = "Penerimaan Bersih"
            cell.lblDescProfil.text = "Rp. " + String(format: "%@", SelfServiceUtility.setSeparateCurrency(Float(gajiBersih)))
        }
//        else if (indexPath.row == 3) {
//            cell.lblTitleProfil.text = "Nama Bank"
//            cell.lblDescProfil.text = "MANDIRI"
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 67.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    /*
    // MARK - UITEXTFIELD DELEGATE
    */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == self.txtPeriod) {
            textField.resignFirstResponder()
        }
    }
    
    /*
     //MARK - UIPickerView Delegate Method
     */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return (self.period.count > 0) ? self.period.count : 0;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return (self.period.count > 0) ? self.period[row].valueForKey("name") as? String : "";
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.periodItem = self.period[row].valueForKey("name") as? String
        self.txtPeriod.text = self.period[row].valueForKey("name") as? String
        self.totPenerimaan = 0
        self.totPotongan = 0
        self.gajiBersih = 0
        SelfServiceUtility.showLoadingView(self.parentViewController!.view)
        self.setupRincianPenerimaanView()
        self.dismissViewControllerAnimated(true, completion: nil)
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
