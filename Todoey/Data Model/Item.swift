//
//  Item.swift
//  Todoey
//
//  Created by Daniel Garcia on 3/6/18.
//  Copyright © 2018 Daniel Garcia. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
