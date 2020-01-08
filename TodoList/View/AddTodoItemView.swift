//
//  AddTodoItemView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/5.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct AddTodoItemView: View {
    // 保存数据使用的环境变量
    @Environment(\.managedObjectContext) var managedObjectContext

    // 点击取消按钮就关闭页面使用的环境变量
    @Environment(\.presentationMode) var presentatonMode: Binding<PresentationMode>

    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "username", ascending: true)]) var users: FetchedResults<User>

    @State private var remindMe = true
    @State var importance = 1
    @State private var newTodoItemDueDate = Date()
    @State private var newTodoItemStartDate = Date()
    @State private var newTodoItemDetail = ""
    @State private var addingTodoItemSuccess = false


    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHHMMSS"
        return formatter
    }()

    let dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        return formatter
    }()


    // form 表格形式
    var body: some View {
        NavigationView {
            Form {

                TextField("What are you gonna do?", text: $newTodoItemDetail)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))

                Toggle(isOn: $remindMe) {
                    Text("Remind Me")
                }

                Picker(selection: $importance, label: Text("Importance")) {
                    Text("Very Important").tag(1)
                    Text("Important").tag(2)
                    Text("Normal").tag(3)
                    Text("Later").tag(4)
                }
                DatePicker(selection: $newTodoItemStartDate, label: { Text("Start Date") })
                DatePicker(selection: $newTodoItemDueDate, label: { Text("Due Date") })

                Spacer()
                Button(action: {
                    // 确认添加该待办事项
                    let newTodoItem = TodoItem(context: self.managedObjectContext)
                    newTodoItem.detail = self.newTodoItemDetail
                    newTodoItem.dueDate = self.newTodoItemDueDate
                    newTodoItem.checked = false
                    newTodoItem.timeStamp = self.dateFormatter.string(from: Date())  // "Jan 8, 2020 at 10:07:21 PM"
                    let parameters: Dictionary = ["email": self.users[0].email,
                                                  "detail": newTodoItem.detail,
                                                  "due": self.dateFormatter2.string(from: newTodoItem.dueDate),
                                                  "checked": newTodoItem.checked,
                                                  "timestamp": newTodoItem.timeStamp, ] as [String: Any]
                    Alamofire.request("https://ruitsai.tech/records_add_api/", method: .post, parameters: parameters)
                            .responseJSON { response in
                                switch response.result.isSuccess {
                                case true:
                                    if let value = response.result.value {
                                        let json = JSON(value)
                                        let state = json[0]["state"].stringValue
                                        if state == "pass" {
                                            // TODO: 跳出一个toast：thanks for register
                                            // 注册框下滑消失
                                            self.presentatonMode.wrappedValue.dismiss()
                                        } else if state == "repeat" {
                                            // TODO: 跳出一个toast：ops,Email has been sign up
                                            print(state)
                                        } else {
                                            print("error")
                                        }

                                    } else {
                                        print("error happened")
                                    }
                                case false:
                                    print(response.result.error)
                                }
                            }


                    // 使用CoreData保存
                    do {
                        try self.managedObjectContext.save()

                        // Todo:这里需要加一个转圈的toast，等待把新的待办事项送到云端

                        self.presentatonMode.wrappedValue.dismiss()
                    } catch {
                        print("***")
                        print(newTodoItem.detail)
                        print(newTodoItem.dueDate)
                        print(newTodoItem.checked)
                        print(error)
                    }
                }) {
                    Text("Conform Adding").foregroundColor(Color.blue).position(x: 170, y: 10).padding()
                }
//                .alert(isPresented: $addingTodoItemSuccess) {
//                    Alert(title: Text("Success"), message: Text("Edit Successfully"))
//                }

                Button(action: {
                    // 取消添加该代办事项
                    self.presentatonMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel Adding").foregroundColor(Color.red).position(x: 170, y: 10).padding()
                }
            }
                    .navigationBarTitle("Add Todo Item")
        }
    }

    func saveTodoItem() {
        do {
            try managedObjectContext.save()
        } catch {

            print(error)
        }
    }
}

struct AddTodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoItemView()
    }
}
