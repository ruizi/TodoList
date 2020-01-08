//
//  TodoListHomeView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/6.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI

let statusBarHeight = UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0
let screen = UIScreen.main.bounds

// 显示todolist以及左侧滑块
struct TodoListHomeView: View {

    @State var showMeau: Bool = false  // 默认不显示侧边栏
    @State var showTodoInToday: Bool = false  // 默认不显示今日待办事项
    @State var showTodoList: Bool = true  // 默认为true
    @State var showCalendar: Bool = false // 默认不显示日历

    var body: some View {
        ZStack {
            // TodoListView
            TodoListView()
                    .offset(x: showTodoList ? 0 : -screen.width)
                    .animation(.spring())

//            .blur(radius: show ? 20 : 0)
//            .scaleEffect(showProfile ? 0.95 : 1)
//            .animation(.default)

//            HomeList()
//                .blur(radius: show ? 20 : 0)
//                .scaleEffect(showProfile ? 0.95 : 1)
//                .animation(.default)
//
//            ContentView()
//                .frame(minWidth: 0, maxWidth: 712)
//                .cornerRadius(30)
//                .shadow(radius: 20)
//                .animation(.spring())
//                .offset(y: showProfile ? 40 + statusBarHeight : screen.height)
            TodoInTodayView()
                    .offset(x: showTodoInToday ? 0 : -screen.width)
                    .animation(.spring())

//            CalendarView()
//                    .offset(x: showCalendar ? 0 : -screen.width)
//                    .animation(.spring())

            MenuButton(showMenu: $showMeau)
                    .offset(x: -40, y: 80)
                    .animation(.spring())



//            MenuRight(show: $showProfile)
//                .offset(x: -16, y: showProfile ? statusBarHeight : 88)
//                .animation(.spring())

            MenuView(showMenu: $showMeau, showTodoInToday: $showTodoInToday, showTodoList: $showTodoList, showCalendar: $showCalendar)

        }
                .background(Color("background"))
                .edgesIgnoringSafeArea(.all)
    }
}

// 左侧点击滑块的按钮
struct MenuButton: View {
    @Binding var showMenu : Bool
    var body: some View {
        VStack() {
            HStack {
                Button(action: {
                    self.showMenu.toggle()
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "list.dash")
                                .foregroundColor(.primary)
                    }
                            .padding(.trailing, 18)
                            .frame(width: 90, height: 60)
                            .background(Color("button"))
                            .cornerRadius(30)
                            .shadow(color: Color("buttonShadow"), radius: 10, x: 0, y: 10)
                }
                Spacer()
            }
            Spacer()
        }
    }
}


struct Menu: Identifiable {
    var id = UUID()
    var title : String
    var icon : String
}

let profileMenu = Menu(title: "Profile", icon: "person.crop.circle")
let settingMenu = Menu(title: "Setting", icon: "gear")
let todayMenu = Menu(title: "Today's", icon: "alarm")
let calendarMenu = Menu(title: "Calendar", icon: "calendar")
let logoutMenu = Menu(title: "Logout", icon: "person.crop.circle.badge.minus")


struct MenuRow: View {
    var image = "person.crop.circle"
    var text = "Hello World!"
    var body: some View {
        HStack {
            Image(systemName: image)
                    .imageScale(.large)
                    .foregroundColor(.red)
                    .frame(width: 32, height: 32)
            Text(text)
                    .foregroundColor(.primary)
                    .font(.headline)
            Spacer()
        }
    }
}

// 左侧的滑块
struct MenuView: View {

    // 保存数据使用的环境变量
    @Environment(\.managedObjectContext) var managedObjectContext

    // 所有的用户
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "username", ascending: true)]) var users: FetchedResults<User>

    // 所有的TodoItem
    @FetchRequest(entity: TodoItem.entity(), sortDescriptors: [NSSortDescriptor(key: "dueDate", ascending: true)]) var todoItems: FetchedResults<TodoItem>

    @Binding var showMenu : Bool
    @State private var showSetting = false
    @Binding var showTodoInToday: Bool
    @Binding var showTodoList: Bool
    @Binding var showCalendar: Bool



    var body: some View {
        HStack {
            if (self.users.count == 1) {// 如果用户处于登录状态
                VStack(alignment: .leading, spacing: 20) {

                    Button(action: {
                        self.showTodoList = true  // 显示所有的代办事项
                        self.showMenu = false   // 不显示菜单栏
                        self.showTodoInToday = false  // 不显示今日待办事项
                        self.showCalendar = false // 不显示日历
                    }) {
                        MenuRow(image: profileMenu.icon, text: self.users[0].username + "'s Todo List")
                    }

                    Button(action: {
                        // 打开设置
                        self.showSetting = true
                    }) {
                        MenuRow(image: settingMenu.icon, text: settingMenu.title)
                    }.sheet(isPresented: $showSetting) {
                        SettingView(oldUsername: self.users[0].username, oldEmail: self.users[0].email)
                                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                    }
                    Button(action: {
                        // 今天到期的事项
                        self.showTodoList = false  // 不显示所有的代办事项
                        self.showMenu = false  //  不显示侧边栏
                        self.showTodoInToday = true  // 展示今天到期的
                        self.showCalendar = false // 不显示日历
                    }) {
                        MenuRow(image: todayMenu.icon, text: todayMenu.title)
                    }


                    Button(action: {
                        // 打开日历
                        self.showTodoList = false
                        self.showTodoInToday = false
                        self.showMenu = false
                        self.showCalendar = true
                    }) {
                        MenuRow(image: calendarMenu.icon, text: calendarMenu.title)
                    }

                    Button(action: {
                        // 登出
                        // 删除用户数据表里的这名用户
                        // 同时清空本地TodoItem数据表中的所有数据
                        let currentUser = self.users[0]
                        self.managedObjectContext.delete(currentUser)
                        do {
                            print("Before Delete CurrentUser", self.users.count)
                            try self.managedObjectContext.save()
                            print("After Delete CurrentUser: ", self.users.count)

                            // Todo:这里需要加一个转圈的toast，等待云端数据库上删除成功

                        } catch {
                            print(error)
                        }

                        // 删除本地TodoItem数据库中的所有记录
                        // 这个操作步骤不用往云端传
                        for todoItem in self.todoItems {
                            self.managedObjectContext.delete(todoItem)
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        }
                    }) {
                        MenuRow(image: logoutMenu.icon, text: logoutMenu.title)
                    }
                    Spacer()
                }
                        .padding(.top, 20)
                        .padding(30)
                        .background(Color("button"))
                        .frame(minWidth: 0, maxWidth: 360)
                        .cornerRadius(30.0)
                        .padding(.trailing, 60)
                        .shadow(radius: 20)
                        .animation(.default)
                        .rotation3DEffect(Angle(degrees: showMenu ? 0 : 60), axis: (x: 0, y: 10.0, z: 0))
                        .offset(x: showMenu ? 0 : -screen.width)
                        .onTapGesture {
                            self.showMenu.toggle()
                        }
                Spacer()
            } else if (self.users.count == 0) {// 如果用户登出了
                HomeView()
            }
        }
                .padding(.top, statusBarHeight)
    }
}

struct TodoListHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showMenu: .constant(true), showTodoInToday: .constant(false), showTodoList: .constant(true), showCalendar: .constant(false))
    }
}


