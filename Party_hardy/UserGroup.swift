//
//  UserGroup.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/23/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class UserGroup: NSObject {
    
    var GroupName : String?
    var objectId : String?
    var ownerId: String?
    var Following:[BackendlessUser] = []
    var Email: String?
    
}