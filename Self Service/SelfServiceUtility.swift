//
//  SelfServiceUtility.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 12/31/16.
//  Copyright © 2016 PT. Jasa Marga, Tbk. All rights reserved.
//

import Foundation
import UIKit

public class SelfServiceUtility {
    
    static var viewLoading: UIView!
    
    static func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    static func getContextMenuList () -> Array<AnyObject> {
        var contextMenuList = Array<AnyObject>()
        
        contextMenuList.append(["menuIcon": "icon_close.png", "menuLabel" : ""])
        contextMenuList.append(["menuIcon": "icon_profil.png", "menuLabel" : "Profil"])
        contextMenuList.append(["menuIcon": "icon_slip_gaji.png", "menuLabel" : "Slip Gaji"])
        contextMenuList.append(["menuIcon": "icon_cuti.png", "menuLabel" : "Cuti"])
        contextMenuList.append(["menuIcon": "icon_absensi.png", "menuLabel" : "Lembur"])
        contextMenuList.append(["menuIcon": "icon_sppd.png", "menuLabel" : "SPPD"])
        contextMenuList.append(["menuIcon": "icon_info_rekan.png", "menuLabel" : "Personal Info"])
        
        return contextMenuList
    }
    
    static func showLoadingView(view: UIView) {
        viewLoading = UIView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
        viewLoading.tag = 200
        viewLoading.backgroundColor = colorWithHexString("000000")
        viewLoading.layer.cornerRadius = 0.0
        viewLoading.layer.masksToBounds = true
        viewLoading.alpha = 0.8
        var loadingImageArray: [UIImage] = []
        for i in 0...35 {
            let strImageName: String = "loading-\(i).png"
            let image = UIImage(named: strImageName)
            loadingImageArray.append(image!)
        }
        let imageView = UIImageView()
        imageView.frame = CGRect(x: viewLoading.bounds.size.width / 2 - 24, y: viewLoading.bounds.size.height / 2 - 24, width: 48, height: 48)
        imageView.animationImages = loadingImageArray
        imageView.animationDuration = 1.0
        imageView.startAnimating()
        viewLoading.addSubview(imageView)
        view.addSubview(viewLoading)
        view.bringSubviewToFront(viewLoading)
    }
    
    static func hideLoadingView(view: UIView) {
        for subview:UIView in view.subviews {
            if (subview.tag == 200) {
                subview.removeFromSuperview()
            }
        }
    }
    
    static func cropImageToWidth(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let tempRect: CGRect = CGRectMake(0, 0, width, height)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage!, tempRect)
        let image: UIImage = UIImage(CGImage: imageRef!)
        return image
    }

    static func setSeparateCurrency(value: Float) -> String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .DecimalStyle
        numberFormatter.maximumFractionDigits = 2
        
        let stringCurrency = numberFormatter.stringFromNumber(NSNumber(double: Double(value)))
        
        return stringCurrency!
    }
    
    static func movedViewUp(movedUp: Bool, view: UIView, pos: CGFloat) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var tempRect = view.frame
        
        if (movedUp) {
            tempRect.origin.y -= pos
            //tempRect.size.height += pos
        }else{
            tempRect.origin.y += pos
            //tempRect.size.height -= pos
        }
        
        view.frame = tempRect
        view.layoutIfNeeded()
        
        UIView.commitAnimations()
    }
    
    static func setupPersonalInfoHeaderFontSize() -> CGFloat {
        let height = UIScreen.mainScreen().bounds.size.height
        
        if (height <= 568) {
            return 24
        }else if (height <= 667) {
            return 36
        }else if (height <= 736) {
            return 48
        }else if (height <= 1024) {
            return 60
        }
        
        return 0
    }
    
    static func setupFontSizeBasedByScreenHeight() -> CGFloat {
        let height = UIScreen.mainScreen().bounds.size.height
        
        if (height <= 568) {
            return 36
        }else if (height <= 667) {
            return 42
        }else if (height <= 736) {
            return 48
        }else if (height <= 1024) {
            return 54
        }
        
        return 0
    }
    
    static func setupViewWidthAndHeightBasedOnRatio( frameRect: CGRect, ratioWidth: CGFloat, ratioHeight: CGFloat) -> CGRect {
        var tempRect = frameRect
        tempRect.origin.y = tempRect.origin.y - 44
        tempRect.size.height = ratioHeight * tempRect.size.height + 44
        tempRect.size.width = ratioWidth * tempRect.size.width
        return tempRect
    }
    
    static func setupRatioWidthBasedOnDeviceScreen() -> CGFloat {
        let width = UIScreen.mainScreen().bounds.size.width
        
        return width / 768
    }
    
    static func setupRatioWidthBasedOnLandscape() -> CGFloat {
        let width = UIScreen.mainScreen().bounds.size.width
        
        return width / 1024
    }
    
    static func setupRatioHeightBasedOnDeviceScreen() -> CGFloat {
        let height = UIScreen.mainScreen().bounds.size.height
        
        return height / 1024
    }
    
    static func setupRatioHeightBasedOnLandscape() -> CGFloat {
        let height = UIScreen.mainScreen().bounds.size.height
        
        return height / 768
    }
    
    static func setupLeftWidthMenuBasedOnDeviceScreen() -> CGFloat {
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        let leftWidth: CGFloat
        if (width > height) {
            leftWidth = 0.85 * height
        }else{
            leftWidth = 0.85 * width
        }
        return leftWidth
    }
    
    static func setupRatioFontBasedOnDeviceScreen(ratioHeight: CGFloat) -> CGFloat {
        if (ratioHeight == 1) {
            return ratioHeight
        }
        else{
            return 768 / 1024
        }
    }
    
}
