//
//  AppManager.swift
//  JSONParsing
//
//  Created by Sourab on 01/04/19.
//  Copyright © 2019 Sourab. All rights reserved.
//

import UIKit

enum serverTypeEnum: String {
    //    case serverTypeProd
    case serverTypeDev = "https://s3.ap-south-1.amazonaws.com/ss-local-files/products.json"
    //    case localIP
}

class AppManager: NSObject {
    static let sharedInstance = AppManager()
    //Change here if we want to change the servertype of the string
    let kServerType = serverTypeEnum.serverTypeDev
    
    func getBaseURL() -> String? {
        print(kServerType.rawValue)
        return kServerType.rawValue
    }
}
