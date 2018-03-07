//
//  Category.swift
//  Todoey
//
//  Created by Daniel Garcia on 3/6/18.
//  Copyright © 2018 Daniel Garcia. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
