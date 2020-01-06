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
    @State var oldTodoItemDueDate = Date()


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
                        // 取消修改该代办事项
                        self.presentatonMode.wrappedValue.dismiss()
                    }) {
                        Text("取消修改")
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        // 先把之前的待办事项删除了
                        let todoItem = self.todoItems[self.index]
                        self.managedObjectContext.delete(todoItem)
                        self.saveTodoItem()
                        
                        // 保存被修改过的待办事项
                        let changedTodoItem = TodoItem(context: self.managedObjectContext)
                        changedTodoItem.detail = self.oldTodoItemDetail
                        changedTodoItem.dueDate = self.oldTodoItemDueDate
                        changedTodoItem.checked = false
                        self.saveTodoItem()
                        
                        self.presentatonMode.wrappedValue.dismiss()
                    }) {
                        Text("确认修改")
                            .padding()
                    }
                }
                
            
                TextField("What are you gonna do?", text: $oldTodoItemDetail)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    //            .foregroundColor(.white)
                
                DatePicker(selection: $oldTodoItemDueDate, displayedComponents: .date, label: { () -> EmptyView in}).padding()
                Text(dateFormatter.string(from: oldTodoItemDueDate))
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

//struct EditingTodoItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditingTodoItemView()
//    }
//}
