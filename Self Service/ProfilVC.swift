//
//  ProfilVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/1/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class ProfilVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let profilCellIdentifier = "profilCell"
    @IBOutlet weak var lblHeaderProfil: UILabel!
    @IBOutlet weak var lblNamaProfil: UILabel!
    @IBOutlet weak var lblJabatanProfil: UILabel!
    @IBOutlet weak var ivPictProfil: UIImageView!
    @IBOutlet weak var tblInfoProfil: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblInfoProfil.registerNib(UINib(nibName: "ProfilCell", bundle: nil), forCellReuseIdentifier: profilCellIdentifier)
        self.tblInfoProfil.delegate = self
        self.tblInfoProfil.dataSource = self
        self.tblInfoProfil.tableFooterView = UIView(frame: CGRectZero)
        self.tblInfoProfil.layer.borderWidth = 2.0
        self.tblInfoProfil.layer.borderColor = SelfServiceUtility.colorWithHexString("FFA726").CGColor
        self.tblInfoProfil.layer.masksToBounds = true
        
        self.lblHeaderProfil.font = self.lblHeaderProfil.font.fontWithSize(SelfServiceUtility.setupFontSizeBasedByScreenHeight())
        
        let shadowTableView: UIView = UIView(frame: self.tblInfoProfil.frame)
        shadowTableView.backgroundColor = UIColor.clearColor()
        shadowTableView.layer.shadowColor = SelfServiceUtility.colorWithHexString("787878").CGColor
        shadowTableView.layer.shadowOffset = CGSizeMake(5, 10)
        shadowTableView.layer.shadowOpacity = 0.3
        shadowTableView.layer.shadowRadius = 2
        self.view.addSubview(shadowTableView)
        shadowTableView.addSubview(self.tblInfoProfil)
        
        self.ivPictProfil.layer.borderWidth = 2.0
        self.ivPictProfil.layer.borderColor = SelfServiceUtility.colorWithHexString("FFA726").CGColor
        self.ivPictProfil.layer.cornerRadius = 25.0
        self.ivPictProfil.layer.masksToBounds = true
        
        self.lblNamaProfil.text = GlobalVariable.sharedInstance.itemLogin[0]["LAST_NAME"] as? String
        self.lblJabatanProfil.text = GlobalVariable.sharedInstance.itemLogin[0]["POSITION_NAME"] as? String
        let urlImage = ConstantAPI.URL_IMAGE + (GlobalVariable.sharedInstance.itemLogin[0]["urlfoto"] as? String)!
        self.loadProfilPict(self.ivPictProfil, urlString: urlImage)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadProfilPict(imageIcon: UIImageView, urlString: String) {
        
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                let tempImage = UIImage(data: response.data!)
                imageIcon.image = SelfServiceUtility.cropImageToWidth(tempImage!, width: (tempImage?.size.width)!, height: (tempImage?.size.width)!)
        }
    }
    
    /*
    // MARK - UITABLEVIEW DELEGATE
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tblInfoProfil.dequeueReusableCellWithIdentifier(profilCellIdentifier) as! ProfilCell
        
        if (indexPath.row == 0) {
            cell.lblTitleProfil.text = "Info Kepegawaian"
            cell.lblDescProfil.text = (GlobalVariable.sharedInstance.itemLogin[0]["EMPLOYMENT_CATEGORY"] as? String)! + ", " + (GlobalVariable.sharedInstance.itemLogin[0]["UNIT_KERJA"] as? String)!
        }else if (indexPath.row == 1) {
            cell.lblTitleProfil.text = "Alamat Kantor"
            cell.lblDescProfil.text = GlobalVariable.sharedInstance.itemLogin[0]["LOCATION_ADDRESS"] as? String
        }else if (indexPath.row == 2) {
            cell.lblTitleProfil.text = "Tempat dan tanggal lahir"
            cell.lblDescProfil.text = (GlobalVariable.sharedInstance.itemLogin[0]["TOWN_OF_BIRTH"] as? String)! + ", " + (GlobalVariable.sharedInstance.itemLogin[0]["DATE_OF_BIRTH"] as? String)!
        }else if (indexPath.row == 3) {
            cell.lblTitleProfil.text = "Agama dan jenis kelamin"
            let gender = ((GlobalVariable.sharedInstance.itemLogin[0]["SEX"] as? String)! == "M") ? "Laki-laki" : "Perempuan"
            cell.lblDescProfil.text = (GlobalVariable.sharedInstance.itemLogin[0]["AGAMA"] as? String)! + ", " + gender
        }else if (indexPath.row == 4) {
            cell.lblTitleProfil.text = "Alamat"
            cell.lblDescProfil.text = GlobalVariable.sharedInstance.itemLogin[0]["ALAMAT"] as? String
        }else if (indexPath.row == 5) {
            cell.lblTitleProfil.text = "Kontak"
            let ktkTelp1 = (GlobalVariable.sharedInstance.itemLogin[0]["TEL_NUMBER_1"] is NSNull) ? "-" : (GlobalVariable.sharedInstance.itemLogin[0]["TEL_NUMBER_1"] as? String)!
            let ktkTelp2 = (GlobalVariable.sharedInstance.itemLogin[0]["TEL_NUMBER_2"] is NSNull) ? "-" : (GlobalVariable.sharedInstance.itemLogin[0]["TEL_NUMBER_2"] as? String)!
            cell.lblDescProfil.text = String(format: "%@, %@", ktkTelp1, ktkTelp2)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 67.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
