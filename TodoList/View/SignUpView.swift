//
//  SignUpView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/6.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var conformedPassword = "" // 第二遍输入的密码
    @State private var email = ""
    
    // @Environment的作用是从环境中取出预定义的值
    // 从实体中获取数据的属性
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // 点击取消按钮就关闭页面使用的环境变量
    @Environment(\.presentationMode) var presentatonMode:Binding<PresentationMode>
    
    var body: some View {
        ZStack{
            Image("designSixBg")
                .resizable()
            VStack{
                // Logo
                Spacer()
                VStack{
                    Text("Welcome")
                        .scaledFont(name: "RobotoSlab-Bold", size: 34)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    Text("Please sign up to continue.")
                        .scaledFont(name: "RobotoSlab-Light", size: 18)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                }
                
                
                Spacer()
                //Form
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 10) {
                        // 输入用户名和密码
                        VStack(alignment: .center, spacing: 30){
                            // 输入用户名
                            VStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing:10){// input username
                                    Image("username")
                                        .frame(width:20,height:20)
                                    CustomTextField(
                                        placeholder: Text("Enter your Username")
                                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))),
                                        text: $username)
                                    if username != "" {
                                        Image("checkmark").foregroundColor(Color.init(.label))
                                    }
                                }
                                Divider()
                                    .background(Color.gray)
                            }
                            
                            // 输入邮箱
                            VStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing:10){// input username
                                    Image("username")
                                        .frame(width:20,height:20)
                                    CustomTextField(
                                        placeholder: Text("Enter your Email")
                                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))),
                                        text: $email)
                                    if email != "" {
                                        Image("checkmark").foregroundColor(Color.init(.label))
                                    }
                                }
                                Divider()
                                    .background(Color.gray)
                            }
                            
                            // 输入密码
                            VStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing:10){// input username
                                    Image("password")
                                        .frame(width:20,height:20)
                                    CustomSecureField(
                                        placeholder: Text("Enter your Password")
                                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))),
                                        password: $password)
                                    if password != "" {
                                        Image("checkmark").foregroundColor(Color.init(.label))
                                    }
                                }
                                Divider()
                                    .background(Color.gray)
                            }
                            
                            // 确认密码
                            VStack(alignment: .leading,spacing: 10) {
                                HStack(alignment: .center, spacing: 10){
                                    Image("password")
                                        .frame(width: 20, height: 20, alignment: .center)
                                    CustomSecureField(
                                        placeholder: Text("Enter your password again").foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))),
                                        password: $conformedPassword
                                    )
                                    if conformedPassword != "" && conformedPassword == password {
                                        Image("checkmark").foregroundColor(Color.init(.label))
                                    }
                                }
                                Divider()
                                    .background(Color.gray)
                            }
                        }
                    }
                    .padding(.horizontal,30)
                    
                    // Button
                    Spacer().frame(height:10)
                    Button(action: {
                        // 把用户的信息存储到数据库中
                        let newUser = User(context: self.managedObjectContext)
                        newUser.auth = "unauthorized"
                        newUser.email = self.email
                        newUser.username = self.username
                        newUser.password = self.password
                        
                        // 使用CoreData保存
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print("***")
                            print(newUser.username)
                            print(newUser.password)
                            print(newUser.email)
                            print(error)
                        }
                        // 注册框下滑消失
                        self.presentatonMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.right")
                            .accentColor(Color.white)
                            .font(.headline)
                            .frame(width:60,height: 60)
                            .background(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                            .cornerRadius(30)
                        
                    }
                    .padding(.bottom, 100)
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
