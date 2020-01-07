//
//  SettingsView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/7.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI


// 设置用户的邮箱、密码、用户名
struct SettingView: View {
    // 保存数据使用的环境变量
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "username", ascending: true)]) var users: FetchedResults<User>
    
    // 点击确认修改按钮就关闭页面这一功能使用的环境变量
    @Environment(\.presentationMode) var presentatonMode:Binding<PresentationMode>
    
    //    @State var toggleOn = true
    //    @State var number = 1
    //    @State var selection = 1
    //
    //    @State var date = Date()
    //    @State var email = ""
    
    // 上一个视图可以传值过来
    @State var oldUsername = ""
    @State var oldEmail = ""
    
    @State private var editUsername = false
    @State private var editEmail = false
    @State private var editPassword = false
    
    @State private var newUsername = ""
    @State private var newEmail = ""
    @State private var newPassword = ""
    @State private var oldPassword = ""
    
    
    var body: some View {
        
//        VStack {
//            HStack {
//                Button(action: {
//                    // 确认修改
//
//                    // 云端
//
//                    self.presentatonMode.wrappedValue.dismiss()
//                }) {
//                    Text("confirm").foregroundColor(Color.blue).position(x:20, y: 20).padding(.leading, 40)
//                }
//                Spacer()
//                Button(action: {
//                    // 取消修改
//
//                    self.presentatonMode.wrappedValue.dismiss()
//                }) {
//                    Text("cancel").foregroundColor(Color.blue).position(x:150, y: 20).padding(.trailing)
//                }
//            }.scaledToFit()
//            Form {
//                HStack {
//                    HStack {
//                        Text("Name:")
//                        if (self.editUsername == false) {
//                            Text(self.oldUsername)
//                        } else {
//                            TextField("What's your new username?", text: $newUsername)
//                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//                        }
//                    }
//                    Spacer()
//                    Button(action: {self.editUsername.toggle()}) {
//                        Image(systemName: "pencil")
//                    }.padding(.trailing)
//                }
//                HStack {
//                    HStack {
//                        Text("Email:")
//                        if (self.editEmail == false) {
//                            Text(self.oldEmail)
//                        } else {
//                            TextField("What's your new email?", text: $newEmail)
//                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//                        }
//                    }
//                    Spacer()
//                    Button(action: {self.editEmail.toggle()}) {
//                        Image(systemName: "pencil")
//                    }.padding(.trailing)
//                }
//
//                if (self.editPassword == false) {
//                    Button(action: {
//                        self.editPassword.toggle()
//                    }) {
//                        Text("Change Password").foregroundColor(Color.blue).position(x:170, y: 10).padding()
//                    }
//                } else {
//                    VStack {
//                        HStack {
//                            Text("Old Password:")
//                            TextField("What's your old password?", text: $oldPassword)
//                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//                        }
//                        HStack {
//                            Text("New Password:")
//                            TextField("What's your new password?", text: $newPassword)
//                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//                        }
//                    }
//                }
//
//                Button(action: {
//
//                    // Todo: 加一个toast等待把这些数据发送到云端
//
//                    self.presentatonMode.wrappedValue.dismiss()
//                }) {
//                    Text("confirm").foregroundColor(Color.blue).position(x:170, y: 10).padding()
//                }
//
//                Button(action: {
//                    self.presentatonMode.wrappedValue.dismiss()
//                }) {
//                    Text("cancel").foregroundColor(Color.blue).position(x:170, y: 10).padding()
//                }
//            }
//            Spacer()
//        }
        NavigationView {
            Form {
                HStack {
                    HStack {
                        Text("Name:")
                        if (self.editUsername == false) {
                            Text(self.oldUsername)
                        } else {
                            TextField("What's your new username?", text: $newUsername)
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        }
                    }
                    Spacer()
                    Button(action: {self.editUsername.toggle()}) {
                        Image(systemName: "pencil")
                    }.padding(.trailing)
                }
                HStack {
                    HStack {
                        Text("Email:")
                        if (self.editEmail == false) {
                            Text(self.oldEmail)
                        } else {
                            TextField("What's your new email?", text: $newEmail)
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        }
                    }
                    Spacer()
                    Button(action: {self.editEmail.toggle()}) {
                        Image(systemName: "pencil")
                    }.padding(.trailing)
                }
                
                if (self.editPassword == false) {
                    Button(action: {
                        self.editPassword.toggle()
                    }) {
                        Text("Change Password").foregroundColor(Color.blue).position(x:170, y: 10).padding()
                    }
                } else {
                    VStack {
                        HStack {
                            Text("Old Password:")
                            TextField("What's your old password?", text: $oldPassword)
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        }
                        HStack {
                            Text("New Password:")
                            TextField("What's your new password?", text: $newPassword)
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        }
                    }
                }
                
                Button(action: {
                    // 保存到数据库中
                    if (true) {
                        print("11", self.users[0].username, self.users[0].email)
                    }
                    if (self.newUsername == "") {// 如果用户没有修改用户名
                        self.newUsername = self.oldUsername
                    }
                    if (self.newEmail == "") {// 如果用户没有修改邮件
                        self.newEmail = self.oldEmail
                    }
                    
                    // TODO: 密码待定
                    
                    self.users[0].username = self.newUsername
                    self.users[0].email = self.newEmail
                    if (true) {
                        print("22", self.users[0].username, self.users[0].email)
                    }
                    
                    do {
                        
                        try self.managedObjectContext.save()
                        
                        // Todo:这里需要加一个转圈的toast，等待把新的待办事项送到云端
                        
                        self.presentatonMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                    }
                    // TODO: 加一个toast等待把这些数据发送到云端
                    
                    self.presentatonMode.wrappedValue.dismiss()
                }) {
                    Text("confirm").foregroundColor(Color.blue).position(x:170, y: 10).padding()
                }
                
                Button(action: {
                    self.presentatonMode.wrappedValue.dismiss()
                }) {
                    Text("cancel").foregroundColor(Color.red).position(x:170, y: 10).padding()
                }
            }.navigationBarTitle("Settings")
        }
    }
}

//        NavigationView {
//            Form {
//                HStack {
//                    HStack {
//                        Text("Name:")
//                        if (self.editUsername == false) {
//                            Text(self.oldUsername)
//                        } else {
//                            TextField("What's your new username?", text: $newUsername)
//                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//                        }
//                    }
//                    Spacer()
//                    Button(action: {self.editUsername.toggle()}) {
//                        Image(systemName: "pencil")
//                    }.padding(.trailing)
//                }
//                HStack {
//                    HStack {
//                        Text("Email:")
//                        if (self.editEmail == false) {
//                            Text(self.oldEmail)
//                        } else {
//                            TextField("What's your new email?", text: $newEmail)
//                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//                        }
//                    }
//                    Spacer()
//                    Button(action: {self.editEmail.toggle()}) {
//                        Image(systemName: "pencil")
//                    }.padding(.trailing)
//                }
//
//                if (self.editPassword == false) {
//                    Button(action: {
//                        self.editPassword.toggle()
//                    }) {
//                        Text("Change Password").foregroundColor(Color.blue).position(x:170, y: 10).padding()
//                    }
//                } else {
//                    VStack {
//                        HStack {
//                            Text("Old Password:")
//                            TextField("What's your old password?", text: $oldPassword)
//                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//                        }
//                        HStack {
//                            Text("New Password:")
//                            TextField("What's your new password?", text: $newPassword)
//                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
//                        }
//                    }
//                }
//
//                Button(action: {
//
//                    // Todo: 加一个toast等待把这些数据发送到云端
//
//                    self.presentatonMode.wrappedValue.dismiss()
//                }) {
//                    Text("confirm").foregroundColor(Color.blue).position(x:170, y: 10).padding()
//                }
//
//                Button(action: {
//                    self.presentatonMode.wrappedValue.dismiss()
//                }) {
//                    Text("cancel").foregroundColor(Color.blue).position(x:170, y: 10).padding()
//                }
//            }
//
//        }.navigationBarTitle("Setting")
//    }



struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
