//
//  EditingTodoItemView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/5.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct EditingTodoItemView: View {
    // 保存数据使用的环境变量
    @Environment(\.managedObjectContext) var managedObjectContext

    // 点击取消按钮就关闭页面使用的环境变量
    @Environment(\.presentationMode) var presentatonMode: Binding<PresentationMode>

    // 依照dueDate的大小升序排列
    @FetchRequest(entity: TodoItem.entity(), sortDescriptors: [NSSortDescriptor(key: "dueDate", ascending: true)]) var todoItems: FetchedResults<TodoItem> // todoItems的类型是FetchedResults<TodoItem>
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "username", ascending: true)]) var users: FetchedResults<User>

    @State var index = 0 // 记录将要被修改的todoItem是todoItems中的第几个
    @State var oldTodoItemDetail = ""
    @State var oldTodoItemStartDate = Date()
    @State var oldTodoItemDueDate = Date()

    @State private var remindMe = true
    @State var importance = 1
    @State private var editingTodoItemSuccess = false


    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
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
                TextField("What are you gonna do?", text: $oldTodoItemDetail)
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
                DatePicker(selection: $oldTodoItemStartDate, label: { Text("Start Date") })
                DatePicker(selection: $oldTodoItemDueDate, label: { Text("Due Date") })

                Spacer()
                Button(action: {
                    // 修改这条待办事项的三个property
                    self.todoItems[self.index].detail = self.oldTodoItemDetail
                    self.todoItems[self.index].dueDate = self.oldTodoItemDueDate
                    self.todoItems[self.index].checked = false
                    let parameters: Dictionary = ["detail": self.todoItems[self.index].detail,
                                                  "dueDate": self.dateFormatter2.string(from:self.todoItems[self.index].dueDate),
                                                  "timestamp": self.todoItems[self.index].timeStamp,
                                                  "email": self.users[0].email, ] as [String: Any]
                    Alamofire.request("https://ruitsai.tech/records_change_api/", method: .post, parameters: parameters)
                            .responseJSON { response in
                                switch response.result.isSuccess {
                                case true:
                                    if let value = response.result.value {

                                        let json = JSON(value)
                                        let state = json[0]["state"].stringValue
                                        if state == "sync success" {
                                            // TODO: 跳出一个toast：thanks for register
                                            print("sync ok")
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
                    do {
                        try self.managedObjectContext.save()

                        // Todo:这里需要加一个转圈的toast，等待把新的待办事项送到云端

                        self.presentatonMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                    }
                }) {
                    Text("Conform Editing").foregroundColor(Color.blue).position(x: 170, y: 10).padding()
                }
//                .alert(isPresented: $editingTodoItemSuccess) {
//                    Alert(title: Text("Success"), message: Text("Edit Successfully"))
//                }

                Button(action: {
                    // 取消添加该代办事项
                    self.presentatonMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel Editing").foregroundColor(Color.red).position(x: 170, y: 10).padding()
                }
            }
                    .navigationBarTitle("Edit Todo Item")
        }
    }
}

struct EditingTodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditingTodoItemView()
    }
}
