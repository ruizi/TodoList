//
//  EditingTodoItemView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/5.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI

struct EditingTodoItemView: View {
    // 保存数据使用的环境变量
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // 点击取消按钮就关闭页面使用的环境变量
    @Environment(\.presentationMode) var presentatonMode:Binding<PresentationMode>
    
    // 依照dueDate的大小升序排列
    @FetchRequest(entity: TodoItem.entity(), sortDescriptors: [NSSortDescriptor(key: "dueDate", ascending: true)]) var todoItems: FetchedResults<TodoItem> // todoItems的类型是FetchedResults<TodoItem>
    
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
    
    // B up
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                    // 取消修改该代办事项
//                    self.presentatonMode.wrappedValue.dismiss()
//                }) {
//                    Text("取消修改")
//                        .padding()
//                }
//                Spacer()
//                Button(action: {
//                    // 先把之前的待办事项删除了
//                    let todoItem = self.todoItems[self.index]
//                    self.managedObjectContext.delete(todoItem)
//                    self.saveTodoItem()
//
//                    // 保存被修改过的待办事项
//                    let changedTodoItem = TodoItem(context: self.managedObjectContext)
//                    changedTodoItem.detail = self.oldTodoItemDetail
//                    changedTodoItem.dueDate = self.oldTodoItemDueDate
//                    changedTodoItem.checked = false
//                    self.saveTodoItem()
//
//                    self.presentatonMode.wrappedValue.dismiss()
//                }) {
//                    Text("确认修改")
//                        .padding()
//                }
//            }
//
//
//            TextField("What are you gonna do?", text: $oldTodoItemDetail)
//                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//            //            .foregroundColor(.white)
//
//            DatePicker(selection: $oldTodoItemDueDate, displayedComponents: .date, label: { () -> EmptyView in}).padding()
//            Text(dateFormatter.string(from: oldTodoItemDueDate))
//            Spacer()
//        }
//        .padding()
//        .background(Color("todoDetails-bg").edgesIgnoringSafeArea(.all))
//    }
    
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
                    // 先把之前的待办事项删除了
                    let todoItem = self.todoItems[self.index]
                    self.managedObjectContext.delete(todoItem)
                    do {
                        try self.managedObjectContext.save()
                        
                        // Todo:这里需要加一个转圈的toast，等待云端数据库上删除成功

                    } catch {
                        print(error)
                    }

                    // 保存修改过后的待办事项
                    let changedTodoItem = TodoItem(context: self.managedObjectContext)
                    // 从What are you gonna do输入框中获取oldTodoItemDetail，这个就是新输入的（更改过后的）新detail
                    changedTodoItem.detail = self.oldTodoItemDetail
                    changedTodoItem.dueDate = self.oldTodoItemDueDate
                    changedTodoItem.checked = false
                    
                    do {
                        try self.managedObjectContext.save()
                        
                        // Todo:这里需要加一个转圈的toast，等待把新的待办事项送到云端
                        
                        self.presentatonMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                    }
                }) {
                    Text("Conform Editing").foregroundColor(Color.blue).position(x:170, y: 10).padding()
                }
//                .alert(isPresented: $editingTodoItemSuccess) {
//                    Alert(title: Text("Success"), message: Text("Edit Successfully"))
//                }
                
                Button(action: {
                    // 取消添加该代办事项
                    self.presentatonMode.wrappedValue.dismiss()
                }){
                    Text("Cancel Editing").foregroundColor(Color.red).position(x:170, y: 10).padding()
                }
            }
            .navigationBarTitle("Edit Todo Item")
        }
    }
    
//    func saveTodoItem() {
//        do {
//            try managedObjectContext.save()
//        } catch {
//            print(error)
//        }
//    }
}

struct EditingTodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditingTodoItemView()
    }
}
