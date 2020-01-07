//
//  TodoItemView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/3.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI

struct TodoItemView: View {
    var checked: Bool
    var dueDate: Date
    var detail: String
    var index: Int  // 记录这个view是在todoItems中的第几个，方便后续对它进行更新操作
    
    @State private var editingTodoItem = false
    
    
    // 一个待办事项的显示，包含dueDate和detail，不显示是否被check
    var body: some View {
        VStack {
            
            HStack {
                Spacer().frame(width: 20)
                Button(action: {
                    // 这项待办事件处于正在编辑的状态
                    self.editingTodoItem.toggle()
                }) {
                    HStack {
                        VStack {
                            Rectangle()
                                .fill(Color("theme"))
                                .frame(width: 8)
                        }// 蓝色小条
                        Spacer().frame(width: 10)
                        VStack {
                            Spacer()
                                .frame(height: 12)
                            HStack {// todo的细节
                                Text("\(self.detail)")
                                    .font(.headline)
                                Spacer()
                            }
                            .foregroundColor(Color("todoItemTitle"))
                            Spacer().frame(height: 4)
                            HStack {
                                Image(systemName: "clock")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                Text(date2Word(date: self.dueDate))
                                    .font(.subheadline)
                                Spacer()
                            }
                            .foregroundColor(Color("todoItemSubTitle"))
                            Spacer()
                                .frame(height: 12)
                        }
                    }
                    .cornerRadius(10.0)
                    .clipped()
                    .shadow(color: Color("todoItemShadow"), radius: 5)
                }.sheet(isPresented: $editingTodoItem) {
                    EditingTodoItemView(index: self.index, oldTodoItemDetail: self.detail, oldTodoItemDueDate: self.dueDate)
                    .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                }
            }
            Spacer().frame(height: 20)
        }
    }
}

//struct TodoItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoItemView(checked: false, dueDate: Date(), detail: "New Item")
//    }
//}
