//
//  StoredItems.swift
//  ToDo2
//
//  Created by Warren Macpro2 on 7/3/18.
//  Copyright © 2018 Warren Hollinger. All rights reserved.
//

import Foundation

//Codable means that this class conforms to encoding and decoding of data stored in .plist
class StoredItems: Codable {
    
    var title : String = ""
    var done : Bool = false
    
    
}
