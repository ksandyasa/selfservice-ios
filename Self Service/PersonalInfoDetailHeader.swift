//
//  PersonalInfoDetailHeader.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/21/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore

class PersonalInfoDetailHeader: GSKStretchyHeaderView {

    @IBOutlet weak var itemHeaderBg: UIImageView!
    @IBOutlet weak var itemHeaderContent: UIView!
    @IBOutlet weak var itemHeaderName: UILabel!
    @IBOutlet weak var itemHeaderJabatan: UILabel!
    @IBOutlet weak var itemHeaderPict: UIImageView!
    @IBOutlet weak var itemHeaderBelt: UIView!
    @IBOutlet weak var itemHeaderIcon: UIImageView!
    @IBOutlet weak var itemHeaderTitle: UILabel!
    @IBOutlet weak var itemHeaderClose: UIButton!
    @IBOutlet weak var itemHeaderPictHeight: NSLayoutConstraint!
    @IBOutlet weak var itemHeaderPictWidth: NSLayoutConstraint!
    @IBOutlet weak var itemHeaderContentHeight: NSLayoutConstraint!
    @IBOutlet weak var itemHeaderBeltHeight: NSLayoutConstraint!
    @IBOutlet weak var itemHeaderIconHeight: NSLayoutConstraint!
    @IBOutlet weak var itemHeaderIconWidth: NSLayoutConstraint!
    @IBOutlet weak var itemHeaderCloseHeight: NSLayoutConstraint!
    @IBOutlet weak var itemHeaderJabatanBottom: NSLayoutConstraint!
    weak var personalInfoDetailHeaderDelegate: DetailPersonalInfoVC!
    @IBOutlet weak var itemHeaderCloseWidth: NSLayoutConstraint!
    @IBOutlet weak var itemHeaderNameBottom: NSLayoutConstraint!
    var personalInfoDetail: Array<AnyObject>! = []
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var kNavBar: Bool! = false

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func didChangeStretchFactor(stretchFactor: CGFloat) {
        print("didChangeStretchFactor")
        var alpha: CGFloat = CGFloatTranslateRange(stretchFactor, 0.2, 0.8, 0, 1)
        alpha = max(0, min(1, alpha));
        
        itemHeaderPict.alpha = alpha
        itemHeaderContent.alpha = alpha
        
        if (kNavBar != nil) {
            let navTitleFactor: CGFloat = 0.4
            var navTitleAlpha: CGFloat = 0.0
            if (stretchFactor < navTitleFactor) {
                navTitleAlpha = CGFloatTranslateRange(stretchFactor, 0, navTitleFactor, 1, 0);
            }
            itemHeaderBelt.alpha = navTitleAlpha;
        }
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SelfServiceUtility.setupRatioWidthBasedOnLandscape() : SelfServiceUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SelfServiceUtility.setupRatioHeightBasedOnLandscape() : SelfServiceUtility.setupRatioHeightBasedOnDeviceScreen()

        self.contentView.bounds.size.width = (orientation == true) ? ratioWidth * 1024 : ratioWidth * 768
        self.contentView.bounds.size.height = (ratioHeight <= 0.56) ? ratioHeight * 330 : (ratioHeight > 0.56 && ratioHeight <= 0.65) ? ratioHeight * 440 : (ratioHeight > 0.65 && ratioHeight <= 0.72) ? ratioHeight * 440 : 220
        self.minimumContentHeight = 65
        self.maximumContentHeight = (ratioHeight <= 0.56) ? ratioHeight * 330 : (ratioHeight > 0.56 && ratioHeight <= 0.65) ? ratioHeight * 440 : (ratioHeight > 0.65 && ratioHeight <= 0.72) ? ratioHeight * 440 : 220
        self.expansionMode = .TopOnly
        if (kNavBar != nil) {
            itemHeaderBelt.hidden = false
        }else{
            itemHeaderBelt.hidden = true
        }
        
        itemHeaderBg.frame = SelfServiceUtility.setupViewWidthAndHeightBasedOnRatio(itemHeaderBg.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        itemHeaderContentHeight.constant = self.contentView.bounds.size.height / 2
        
        itemHeaderJabatan.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemHeaderJabatan.numberOfLines = 0
        itemHeaderJabatan.font = itemHeaderJabatan.font.fontWithSize(SelfServiceUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        itemHeaderJabatan.sizeToFit()
        
        itemHeaderName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemHeaderName.numberOfLines = 0
        itemHeaderName.font = itemHeaderName.font.fontWithSize(SelfServiceUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 22)
        itemHeaderName.sizeToFit()
        
        itemHeaderJabatan.frame = SelfServiceUtility.setupViewWidthAndHeightBasedOnRatio(itemHeaderJabatan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        itemHeaderName.frame = SelfServiceUtility.setupViewWidthAndHeightBasedOnRatio(itemHeaderName.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        itemHeaderJabatanBottom.constant = ratioHeight * itemHeaderJabatanBottom.constant
        itemHeaderNameBottom.constant = ratioWidth * itemHeaderNameBottom.constant
        
        itemHeaderPictHeight.constant = ratioHeight * itemHeaderPictHeight.constant
        itemHeaderPictWidth.constant = itemHeaderPictHeight.constant
        //let cornerRadius = itemHeaderPictHeight.constant
        itemHeaderPict.layer.cornerRadius = 10.0
        itemHeaderPict.layer.masksToBounds = true
        
        //let cornerRadius1 = itemHeaderIconHeight.constant
        itemHeaderIcon.layer.cornerRadius = 10.0
        itemHeaderIcon.layer.masksToBounds = true
        
        itemHeaderTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemHeaderTitle.numberOfLines = 0
        itemHeaderTitle.font = itemHeaderTitle.font.fontWithSize(SelfServiceUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20)
        itemHeaderTitle.sizeToFit()
        
        itemHeaderTitle.frame = SelfServiceUtility.setupViewWidthAndHeightBasedOnRatio(itemHeaderTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(PersonalInfoDetailHeader.dismissDetailPersonalInfoFromHeader(_:)))
        self.contentView.addGestureRecognizer(gesture)
    }
    
    func setupPersonalInfoDetailView() {
        print(personalInfoDetail.description)
        let urlFoto = String(format: "%@%@", ConstantAPI.URL_IMAGE, (personalInfoDetail[0]["urlfoto"] as? String)!)
        self.setupPersonalInfoPict(itemHeaderPict, urlString: urlFoto)
        self.setupPersonalInfoPict(itemHeaderIcon, urlString: urlFoto)
        
        itemHeaderName.text = personalInfoDetail[0]["LAST_NAME"] as? String
        itemHeaderJabatan.text = personalInfoDetail[0]["POSITION_NAME"] as? String
        itemHeaderTitle.text = personalInfoDetail[0]["LAST_NAME"] as? String
    }
    
    func setupPersonalInfoPict(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                let tempImage = UIImage(data: response.data!)
                imageIcon.image = SelfServiceUtility.cropImageToWidth(tempImage!, width: (tempImage?.size.width)!, height: (tempImage?.size.width)!)
        }
    }
    
    func dismissDetailPersonalInfoFromHeader(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocityInView(self.contentView)
        if (velocity.y >= 0) {
            if (self.personalInfoDetailHeaderDelegate.isKindOfClass(DetailPersonalInfoVC)) {
                self.personalInfoDetailHeaderDelegate.dismissDetailPersonalInfo(recognizer)
            }
        }
        
    }

    @IBAction func closePersonalInfoListDetail(sender: UIButton) {
//        personalInfoDetailHeaderDelegate.dismissPersonalInfoDetailFromHeader()
    }
}
