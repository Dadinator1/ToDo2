//
//  Category.swift
//  ToDo2
//
//  Created by Warren Macpro2 on 7/3/18.
//  Copyright © 2018 Warren Hollinger. All rights reserved.
//

import Foundation
import Foundation
import  RealmSwift

//create Realm Object class
class Category: Object {
    // For Realm properties we need to start declaration with @objc dynamic  before var
    @objc dynamic var name: String = ""
    //sets up relationship to parent table
    let items = List<StoredItems>()
}
