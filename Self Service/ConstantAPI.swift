//
//  ConstantAPI.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/4/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import Foundation
import UIKit

public class ConstantAPI {
    
    static let BASEURL: String = "http://Jmact.jasamarga.co.id:8000/selfservice"
    //static let BASEURL: String = "http://selfservice.g8tech.net"
    
    static let API_POST_LOGIN = BASEURL + "/api/login"
    
    static let API_POST_RINCIAN_PENERIMAAN = BASEURL + "/api/slipgaji/rincianpenerimaan"
    
    static let API_POST_RINCIAN_POTONGAN = BASEURL + "/api/slipgaji/rincianpotongan"
    
    static let API_POST_PERIOD = BASEURL + "/api/period"
    
    static let API_POST_SANTUNAN_DUKA = BASEURL + "/api/santunanduka"

    static let API_POST_PERSONAL_INFO = BASEURL + "/api/personalinfo"
    
    static let API_POST_PERSONAL_INFO_ATASAN = BASEURL + "/api/getatasan"
    
    static let API_POST_PERSONAL_INFO_BAWAHAN = BASEURL + "/api/getbawahan"
    
    static let API_POST_PERSONAL_INFO_PEER = BASEURL + "/api/getpeer"
    
    static let URL_IMAGE = "http://www.jasamarga.com/SMARTBOOK/"
    
}
