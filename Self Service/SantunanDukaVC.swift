//
//  SantunanDukaVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 4/12/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit

class SantunanDukaVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    let santunanDukaCellIdentifier: String! = "rincianFooter"
    var santunanDuka: Array<AnyObject>! = []
    @IBOutlet weak var santunanDukaList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(SantunanDukaVC.dismissSantunanDuka))
        self.view.addGestureRecognizer(gesture)
        
        self.santunanDukaList.registerNib(UINib(nibName: "SantunanDukaCell", bundle: nil), forCellReuseIdentifier: santunanDukaCellIdentifier)
        
        self.santunanDukaList.delegate = self
        self.santunanDukaList.dataSource = self
        self.santunanDukaList.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.3, animations: { [weak self] in
            self!.view.frame = CGRect(x: 6, y: (self?.view.frame.height)! / 2, width: (self?.view.frame.width)! - 12, height: (self?.santunanDukaList.contentSize.height)! - 12)
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
    
    func dismissSantunanDuka(recognizer: UIPanGestureRecognizer) {
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
     // MARK - UITABLEVIEW DELEGATE
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.santunanDuka.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let className = String(SantunanDukaCell.self)
        let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        
        let cell = nibViews!.first as! SantunanDukaCell
        
        if (self.santunanDuka.count > 0) {
            cell.santunanDukaTitle.text = String(format: "%@", self.santunanDuka[indexPath.row]["keterangan"] as! String)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
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
