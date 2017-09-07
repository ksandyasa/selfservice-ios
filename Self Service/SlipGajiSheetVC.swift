//
//  SlipGajiSheetVC.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/4/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit

class SlipGajiSheetVC: UIViewController {
    
    let fullView: CGFloat = 114
    var partialView: CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    weak var slipGajiSheetDelegate: SlipGajiVC!
    @IBOutlet weak var ivRincianPenerimaan: UIImageView!
    @IBOutlet weak var ivRincianPotongan: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ivRincianPenerimaan.image = self.ivRincianPenerimaan.image?.imageWithRenderingMode(.AlwaysTemplate)
        self.ivRincianPenerimaan.tintColor = SelfServiceUtility.colorWithHexString("FF210C")
        
        self.ivRincianPotongan.image = self.ivRincianPotongan.image?.imageWithRenderingMode(.AlwaysTemplate)
        self.ivRincianPotongan.tintColor = SelfServiceUtility.colorWithHexString("FF210C")
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(SlipGajiSheetVC.panGesture))
        self.view.addGestureRecognizer(gesture)
        
        let tapRincianPenerimaan = UITapGestureRecognizer(target:self, action:#selector(showRincianPenerimaanFromMenu))
        self.ivRincianPenerimaan.addGestureRecognizer(tapRincianPenerimaan)
        
        let tapRincianPotongan = UITapGestureRecognizer(target:self, action:#selector(showRincianPotonganFromMenu))
        self.ivRincianPotongan.addGestureRecognizer(tapRincianPotongan)
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
    
    func panGesture(recognizer: UIPanGestureRecognizer) {
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
                let yComponent = UIScreen.mainScreen().bounds.height - 134
                self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
                })
        }
        
    }
    
    func showRincianPenerimaanFromMenu() {
        if (self.slipGajiSheetDelegate.isKindOfClass(SlipGajiVC)) {
            self.slipGajiSheetDelegate.showRincianPenerimaanViews()
        }
    }
    
    func showRincianPotonganFromMenu() {
        if (self.slipGajiSheetDelegate.isKindOfClass(SlipGajiVC)) {
            self.slipGajiSheetDelegate.showRincianPotonganViews()
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
