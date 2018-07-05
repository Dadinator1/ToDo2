//
//  StoredItems.swift
//  ToDo2
//
//  Created by Warren Macpro2 on 7/3/18.
//  Copyright © 2018 Warren Hollinger. All rights reserved.
//

import Foundation
import  RealmSwift

class StoredItems: Object {
    // For Realm properties we need to start declaration with @objc dynamic  before var
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //Defining the inverse relationship of items - in this case the other table it is linked to
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
