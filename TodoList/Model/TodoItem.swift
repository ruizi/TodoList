//
//  TodoItem.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/3.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import CoreData

class TodoItem: NSManagedObject {
    @NSManaged var checked: Bool
    @NSManaged var dueDate: Date
    @NSManaged var detail: String
}
