//
//  User.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/6.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import CoreData

class User: NSManagedObject {
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var email: String
    @NSManaged var auth: String
}
