//
//  AddTodoItemView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/5.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI

struct AddTodoItemView: View {
    // 保存数据使用的环境变量
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // 点击取消按钮就关闭页面使用的环境变量
    @Environment(\.presentationMode) var presentatonMode:Binding<PresentationMode>
    
    
    @State private var newTodoItemDueDate = Date()
    @State private var newTodoItemDetail = ""
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    // 取消添加该代办事项
                    self.presentatonMode.wrappedValue.dismiss()
                }) {
                    Text("取消添加")
                        .padding()
                }
                Spacer()
                Button(action: {
                    // 确认添加该待办事项
                    let newTodoItem = TodoItem(context: self.managedObjectContext)
                    newTodoItem.detail = self.newTodoItemDetail
                    newTodoItem.dueDate = self.newTodoItemDueDate
                    newTodoItem.checked = false

                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print("***")
                        print(newTodoItem.detail)
                        print(newTodoItem.dueDate)
                        print(newTodoItem.checked)
                        print(error)
                    }
                    // 使用CoreData保存
                    
                    self.presentatonMode.wrappedValue.dismiss()
                }) {
                    Text("确认添加")
                        .padding()
                }
            }
            
        
            TextField("What are you gonna do?", text: $newTodoItemDetail)
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//            .foregroundColor(.white)
            
            DatePicker(selection: $newTodoItemDueDate, displayedComponents: .date, label: { () -> EmptyView in}).padding()
            Text(dateFormatter.string(from: newTodoItemDueDate))
            Spacer()
        }
        .padding()
        .background(Color("todoDetails-bg").edgesIgnoringSafeArea(.all))
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
