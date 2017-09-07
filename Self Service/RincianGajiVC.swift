//
//  RincianGajiVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/10/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class RincianGajiVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let rincianSectionIdentifier: String! = "rincianSection"
    let rincianCellIdentifier: String! = "rincianCell"
    let rincianSubTotalCellIdentifier: String! = "rincianSubTotalCell"
    let rincianFooterIdentifier: String! = "rincianFooter"
    var santunanDukaVC: SantunanDukaVC!
    weak var rincianGajiDelegate: SlipGajiVC!
    var rincianMode: Int = 0
    var totalKompensasiTetap: Int64 = 0
    var totalKompensasiLain: Int64 = 0
    var totalTunjanganTetap: Int64 = 0
    var totalTunjanganLain: Int64 = 0
    var totalPotonganIuranPajak: Int64 = 0
    var totalPotonganLain: Int64 = 0
    var totalRincian: Int64 = 0
    var totalGaji: Int64 = 0
    var totalPotongan: Int64 = 0
    var penerimaanBersih: Int64 = 0;
    var rincianItems: Array<AnyObject>! = []
    var santunanDuka: Array<AnyObject>! = []
    var kompensasiTetapItems: Array<AnyObject>! = []
    var kompensasiLainItems: Array<AnyObject>! = []
    var tunjanganTetapItems: Array<AnyObject>! = []
    var tunjanganLainItems: Array<AnyObject>! = []
    var potonganIuranPajakItems:Array<AnyObject>! = []
    var potonganLainItems: Array<AnyObject>! = []
    @IBOutlet weak var lblRincianHeader: UILabel!
    @IBOutlet weak var tblRincian: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(RincianGajiVC.dismissRincianGaji))
        self.view.addGestureRecognizer(gesture)
        
        self.tblRincian.registerNib(UINib(nibName: "RincianSection", bundle: nil), forHeaderFooterViewReuseIdentifier: rincianSectionIdentifier)
        self.tblRincian.registerNib(UINib(nibName: "RincianCell", bundle: nil), forCellReuseIdentifier: rincianCellIdentifier)
        self.tblRincian.registerNib(UINib(nibName: "RincianSubTotalCell", bundle: nil), forHeaderFooterViewReuseIdentifier: rincianSubTotalCellIdentifier)
        self.tblRincian.registerNib(UINib(nibName: "RincianFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: rincianFooterIdentifier)
        self.tblRincian.delegate = self
        self.tblRincian.dataSource = self
        self.tblRincian.tableFooterView = UIView(frame: CGRectZero)
        
        if (self.rincianMode == 0) {
            self.lblRincianHeader.text = "RINCIAN PENERIMAAN"
            self.setupRincianPenerimaan()
        }else{
            self.lblRincianHeader.text = "RINCIAN POTONGAN"
            self.setupRincianPotongan()
        }
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
    
    func setupRincianPenerimaan() {
        self.setupKompensasiBulananTetap()
        self.setupKompensasiLain()
        self.setupTunjanganTetap()
        self.setupTunjanganLain()
        self.setupRincianFooter()
    }
    
    func setupRincianPotongan() {
        self.setupPotonganIuranPajak()
        self.setupPotonganLain()
        self.setupRincianFooter()
    }
    
    func setupRincianFooter() {
        let className = String(RincianFooter.self)
        let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        
        let cell = nibViews!.first as! RincianFooter
        
        cell.lblTotalTitle.text = "Total"
        cell.lblTotalDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.totalRincian)))
        
        cell.lblTotalGajiTitle.text = "Total Gaji"
        cell.lblTotalGajiDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.totalGaji)))
        
        cell.lblTotalPotonganTitle.text = "Total Potongan"
        cell.lblTotalPotonganDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.totalPotongan)))
        
        cell.lblPenerimaanBersihTitle.text = "Penerimaan Bersih"
        cell.lblPenerimaanBersihDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.penerimaanBersih)))
        
        cell.backgroundColor = SelfServiceUtility.colorWithHexString("FFFFFF")
        cell.contentView.backgroundColor = SelfServiceUtility.colorWithHexString("FFFFFF")
        
        self.tblRincian.tableFooterView = cell.contentView
    }
    
    func setupKompensasiBulananTetap() {
        for (index, element) in self.rincianItems.enumerate() {
            print(index, ":", element)
            if (element["nama"] as? String != "<null>") {
                if (element["nama"] as? String == "Kompensasi Bulanan Tetap") {
                    self.kompensasiTetapItems.append(element)
                    self.totalKompensasiTetap = self.totalKompensasiTetap + (element["value_penerimaan"] as? Int)!
                }
            }
        }
        
        self.totalRincian = self.totalRincian + self.totalKompensasiTetap
        
        print(self.kompensasiTetapItems.description)
    }
    
    func setupKompensasiLain() {
        for (index, element) in self.rincianItems.enumerate() {
            print(index, ":", element)
            if (element["nama"] as? String != "<null>") {
                if (element["nama"] as? String == "Kompensasi Lainnya") {
                    self.kompensasiLainItems.append(element)
                    self.totalKompensasiLain = self.totalKompensasiLain + (element["value_penerimaan"] as? Int)!
                    self.totalRincian = self.totalRincian + (element["value_penerimaan"] as? Int)!
                }
            }
        }
        
        self.totalKompensasiLain = self.totalKompensasiLain + self.totalKompensasiTetap
        
        print(self.kompensasiLainItems.description)
    }
    
    func setupTunjanganTetap() {
        for (index, element) in self.rincianItems.enumerate() {
            print(index, ":", element)
            if (element["nama"] as? String != "<null>") {
                if (element["nama"] as? String == "Tunjangan Lainnya") {
                    self.tunjanganTetapItems.append(element)
                    self.totalTunjanganTetap = self.totalTunjanganTetap + (element["value_penerimaan"] as? Int)!
                }
            }
        }
        
        self.totalRincian = self.totalRincian + self.totalTunjanganTetap
        
        print(self.tunjanganTetapItems.description)
    }
    
    func setupTunjanganLain() {
        for (index, element) in self.rincianItems.enumerate() {
            print(index, ":", element)
            if (element["nama"] as? String != "<null>") {
                if (element["nama"] as? String == "Lain-lain") {
                    self.tunjanganLainItems.append(element)
                    self.totalTunjanganLain = self.totalTunjanganLain + (element["value_penerimaan"] as? Int)!
                }
            }
        }
        
        self.totalRincian = self.totalRincian + self.totalTunjanganLain
        
        print(self.tunjanganLainItems.description)
    }
    
    func setupPotonganIuranPajak() {
        for (index, element) in self.rincianItems.enumerate() {
            print(index, ":", element)
            if (element["nama"] as? String != "<null>") {
                if (element["nama"] as? String == "Ketidakhadiran, Iuran dan Pajak") {
                    self.potonganIuranPajakItems.append(element)
                    self.totalPotonganIuranPajak = self.totalPotonganIuranPajak + (element["value_potongan"] as? Int)!
                }
            }
        }
        
        self.totalRincian = self.totalRincian + self.totalPotonganIuranPajak
        
        print(self.potonganIuranPajakItems.description)
    }
    
    func setupPotonganLain() {
        for (index, element) in self.rincianItems.enumerate() {
            print(index, ":", element)
            if (element["nama"] as? String != "<null>") {
                if (element["nama"] as? String == "Lain-lain") {
                    self.potonganLainItems.append(element)
                    self.totalPotonganLain = self.totalPotonganLain + (element["value_potongan"] as? Int)!
                }
            }
        }
        
        self.totalRincian = self.totalRincian + self.totalPotonganLain
        
        print(self.potonganLainItems.description)
    }
    
    func dismissRincianGaji(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocityInView(self.view)
        if (velocity.y >= 0) {
            UIView.animateWithDuration(0.3, animations: { [weak self] in
                let frame = self?.view.frame
                let yComponent = UIScreen.mainScreen().bounds.height
                self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
                })
        }
        
    }
    
    func showSantunanDukaViews() {
        print("Rincian Penerimaan")
        if (self.santunanDukaVC != nil) {
            self.santunanDukaVC.view.removeFromSuperview()
            self.santunanDukaVC.removeFromParentViewController()
            self.santunanDukaVC = nil
        }
        
        self.santunanDukaVC = SantunanDukaVC(nibName: "SantunanDukaVC", bundle: nil)
        self.santunanDukaVC.santunanDuka = self.santunanDuka
        self.parentViewController?.addChildViewController(self.santunanDukaVC)
        self.parentViewController?.view.addSubview(self.santunanDukaVC.view)
        self.parentViewController?.view.bringSubviewToFront(self.santunanDukaVC.view)
        self.santunanDukaVC.didMoveToParentViewController(self.parentViewController)
        self.santunanDukaVC.view.frame = CGRectMake(0, self.view.frame.maxY, self.view.frame.size.width, 375)
    }
    
    /*
    // MARK - UITABLEVIEW DELEGATE
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.rincianMode == 0) ? 4 : 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.rincianMode == 0) {
            if (section == 0) {
                return self.kompensasiTetapItems.count
            }else if (section == 1) {
                return self.kompensasiLainItems.count
            }else if (section == 2) {
                return self.tunjanganTetapItems.count
            }else if (section == 3) {
                return self.tunjanganLainItems.count
            }
        }else{
            if (section == 0) {
                return self.potonganIuranPajakItems.count
            }else if (section == 1) {
                return self.potonganLainItems.count
            }
        }
        return (self.rincianItems != nil) ? self.rincianItems.count : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let className = String(RincianSection.self)
        let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        
        let cell = nibViews!.first as! RincianSection
        
        if (self.rincianMode == 0) {
            if (section == 0) {
                cell.lblTitle.text = "a. Kompensasi Bulanan Tetap"
            }else if (section == 1) {
                cell.lblTitle.text = "b. Kompensasi Lainnya"
            }else if (section == 2) {
                cell.lblTitle.text = "c. Tunjangan Lainnya\nIuran dan Pajak"
            }else if (section == 3) {
                cell.lblTitle.text = "d. Lain-lain"
            }
        }else{
            if (section == 0) {
                cell.lblTitle.text = "a. Ketidakhadiran, Iuran dan Pajak"
            }else if (section == 1) {
                cell.lblTitle.text = "b. Lain-lain"
            }
        }
        
        cell.backgroundColor = SelfServiceUtility.colorWithHexString("FFFFFF")
        cell.contentView.backgroundColor = SelfServiceUtility.colorWithHexString("FFFFFF")
        
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let className = String(RincianCell.self)
        let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        
        let cell = nibViews!.first as! RincianCell
        
        if (self.rincianMode == 0) {
            if (indexPath.section == 0) {
                cell.lblRincianTitle.text = String(format: "%d. %@", (indexPath.row + 1), self.kompensasiTetapItems[indexPath.row]["reporting_name"] as! String)
                cell.lblRincianDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.kompensasiTetapItems[indexPath.row]["value_penerimaan"] as! Int)))
            }else if (indexPath.section == 1) {
                cell.lblRincianTitle.text = String(format: "%d. %@", (indexPath.row + 1), self.kompensasiLainItems[indexPath.row]["reporting_name"] as! String)
                cell.lblRincianDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.kompensasiLainItems[indexPath.row]["value_penerimaan"] as! Int)))
            }else if (indexPath.section == 2) {
                cell.lblRincianTitle.text = String(format: "%d. %@", (indexPath.row + 1), self.tunjanganTetapItems[indexPath.row]["reporting_name"] as! String)
                cell.lblRincianDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.tunjanganTetapItems[indexPath.row]["value_penerimaan"] as! Int)))
            }else if (indexPath.section == 3) {
                cell.lblRincianTitle.text = String(format: "%d. %@", (indexPath.row + 1), self.tunjanganLainItems[indexPath.row]["reporting_name"] as! String)
                cell.lblRincianDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.tunjanganLainItems[indexPath.row]["value_penerimaan"] as! Int)))
            }
        }else{
            if (indexPath.section == 0) {
                if (self.potonganIuranPajakItems[indexPath.row]["reporting_name"] as! String == "Pot. Santunan Duka") {
                    print(self.potonganIuranPajakItems[indexPath.row]["reporting_name"])
                    let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
                    let underlineAttributedString = NSAttributedString(string: String(format: "%d. %@", (indexPath.row + 1), self.potonganIuranPajakItems[indexPath.row]["reporting_name"] as! String), attributes: underlineAttribute)
                    cell.lblRincianTitle.attributedText = underlineAttributedString
                    cell.lblRincianTitle.textColor = SelfServiceUtility.colorWithHexString("0D7BD4")
                    
                    let gesture = UITapGestureRecognizer.init(target: self, action: #selector(RincianGajiVC.showSantunanDukaViews))
                    cell.lblRincianTitle.addGestureRecognizer(gesture)
                }else{
                    cell.lblRincianTitle.text = String(format: "%d. %@", (indexPath.row + 1), self.potonganIuranPajakItems[indexPath.row]["reporting_name"] as! String)
                }
                cell.lblRincianDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.potonganIuranPajakItems[indexPath.row]["value_potongan"] as! Int)))
            }else if (indexPath.section == 1) {
                cell.lblRincianTitle.text = String(format: "%d. %@", (indexPath.row + 1), self.potonganLainItems[indexPath.row]["reporting_name"] as! String)
                cell.lblRincianDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(self.potonganLainItems[indexPath.row]["value_potongan"] as! Int)))
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let className = String(RincianSubTotalCell.self)
        let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        
        let cell = nibViews!.first as! RincianSubTotalCell
        
        cell.lblRincianSubTotalTitle.text = "Subtotal"
        if (self.rincianMode == 0) {
            if (section == 0) {
                cell.lblRincianSubTotalDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(totalKompensasiTetap)))
            }else if (section == 1) {
                cell.lblRincianSubTotalDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(totalKompensasiLain)))
            }else if (section == 2) {
                cell.lblRincianSubTotalDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(totalTunjanganTetap)))
            }else if (section == 3) {
                cell.lblRincianSubTotalDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(totalTunjanganLain)))
            }
        }else{
            if (section == 0) {
                cell.lblRincianSubTotalDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(totalPotonganIuranPajak)))
            }else if (section == 1) {
                cell.lblRincianSubTotalDetail.text = String(format: "Rp. %@", SelfServiceUtility.setSeparateCurrency(Float(totalPotonganLain)))
            }
        }
        
        cell.backgroundColor = SelfServiceUtility.colorWithHexString("FFFFFF")
        cell.contentView.backgroundColor = SelfServiceUtility.colorWithHexString("FFFFFF")
        
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
