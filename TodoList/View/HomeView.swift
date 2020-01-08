//
//  HomeView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/6.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

//enum UserStatus {
//    case showingLoginView
//    case showingTodoListView
//}


struct HomeView: View {// 默认展示登陆界面

    // 获取所有的user
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "username", ascending: true)]) var users: FetchedResults<User>

    var body: some View {
        HStack {
            if self.users.count == 0 || self.users[0].auth == "unauthorized" {
                LoginView()
                        .animation(.easeInOut)
            } else if (self.users.count == 1 && self.users[0].auth == "authorized") {

//                var parameters: Dictionary = ["email": self.users[0].email,]
//                Alamofire.request("https://ruitsai.tech/records_init_sync_api/", method: .post, parameters: parameters)
//                        .responseJSON { response in
//                            switch response.result.isSuccess {
//                            case true:
//                                if let value = response.result.value {
//                                    let json = JSON(value)
//
//                                    print(json)
//                                    // 把用户的日程信息存入数据库
//                                    for (index, subJson): (String, JSON) in json {
//                                        let detail = subJson["detail"].stringValue
//                                        var Year = subJson["Year"].stringValue
//                                        var Month = subJson["Month"].stringValue
//                                        var Day = subJson["Day"].stringValue
//
//                                        let timestamp = subJson["timestamp"].stringValue
//                                        let newTodoItem = TodoItem(context: self.managedObjectContext)
//                                        newTodoItem.detail = detail
//                                        newTodoItem.dueDate = Date(year: Int(Year) ?? 2020, month: Int(Month) ?? 01, day: Int(Day) ?? 10)
//                                        newTodoItem.checked = false
//                                        newTodoItem.timeStamp = timestamp  // 20200108234117
//                                        // 使用CoreData保存
//                                        do {
//                                            try self.managedObjectContext.save()
//                                        } catch {
//                                            print("***")
//                                            print(newTodoItem.detail)
//                                            print(newTodoItem.dueDate)
//                                            print(newTodoItem.checked)
//                                            print(error)
//                                        }
//                                    }
//
//
//                                } else {
//                                    // TODO: 跳出一个弹框：network errors
//                                    print("error happened")
//                                }
//                            case false:
//                                print(response.result.error)
//                            }
//                        }

                TodoListHomeView()
                        .animation(.easeInOut)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
