//
// Created by 尹毓康 on 2020/1/8.
// Copyright (c) 2020 yukangyin. All rights reserved.
//

import SwiftUI


// 设置用户的邮箱、密码、用户名
struct ForgetPassWordView: View {
    // 保存数据使用的环境变量
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "username", ascending: true)]) var users: FetchedResults<User>

    // 点击确认修改按钮就关闭页面这一功能使用的环境变量
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // 收验证码的邮箱
    @State private var email: String = ""

    // 从邮箱中查看的authCode
    @State private var authCode: String = ""

    // 输入的新密码
    @State private var newPassword: String = ""

    // 再次输入的新密码
    @State private var newPasswordAgain: String = ""


    var body: some View {
        ZStack {
            Image("designSixBg")
                    .resizable()
            VStack {
                // Logo
                Spacer()
                VStack {
                    Text("Welcome")
                            .scaledFont(name: "RobotoSlab-Bold", size: 34)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    Text("Please Reset your password.")
                            .scaledFont(name: "RobotoSlab-Light", size: 18)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                }


                Spacer()
                //Form
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 10) {

                        VStack(alignment: .center, spacing: 30) {
                            // 输入email
                            VStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing: 10) {// input username
                                    Image(systemName: "envelope")
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    CustomTextField(
                                            placeholder: Text("Enter your Email")
                                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))),
                                            text: $email)

                                    if email != "" {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                                    }
                                }
                                Divider()
                                        .background(Color.gray)
                            }

                            // 输入authCode
                            VStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing: 10) {// input username
                                    Image(systemName: "lock.shield")
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    CustomTextField(
                                            placeholder: Text("Enter your AuthCode")
                                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))),
                                            text: $authCode)
                                    // 如果authCode不为空，就显示checkmark
                                    // TODO: 与云端正确的checkmar比较，如果正确了，再显示checkmark
                                    if authCode != "" {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                                    }
                                }
                                Divider()
                                        .background(Color.gray)
                            }

                            // 输入newPassword
                            VStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing: 10) {// input username
                                    Image(systemName: "lock")
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    CustomSecureField(
                                            placeholder: Text("Enter your Password")
                                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))),
                                            password: $newPassword)
                                    // 如果新密码不为空，就显示checkmark
                                    if newPassword != "" {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                                    }
                                }
                                Divider()
                                        .background(Color.gray)
                            }

                            // 再次输入newPassword(newPasswordAgain)
                            VStack(alignment: .center, spacing: 10) {
                                HStack(alignment: .center, spacing: 10) {// input username
                                    Image(systemName: "lock")
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                    CustomSecureField(
                                            placeholder: Text("Enter your Password Again")
                                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))),
                                            password: $newPasswordAgain)
                                    // 如果第二次输入的新密码不为空并且和第一次输入的新密码一样，就显示checkmark
                                    if newPasswordAgain != "" && newPasswordAgain == newPassword {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                                    }
                                }
                                Divider()
                                        .background(Color.gray)
                            }
                        }
                    }
                            .padding(.horizontal, 30)

                    // Button
                    Spacer().frame(height: 10)

                    HStack {
                        Button(action: {
                            // 点击后向发送邮件
                        }) {
                            Image(systemName: "arrow.right")
                                    .accentColor(Color.white)
                                    .font(.headline)
                                    .frame(width: 60, height: 60)
                                    .background(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                                    .cornerRadius(30)

                        }.padding(.bottom, 100)

                        Button(action: {
                            // TODO: 把修改后的密码存到云端数据库

                            // ForgetPasswordView消失
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.right")
                                    .accentColor(Color.white)
                                    .font(.headline)
                                    .frame(width: 60, height: 60)
                                    .background(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                                    .cornerRadius(30)

                        }.padding(.bottom, 100)
                    }
                }
                Spacer()
            }
        }
                .edgesIgnoringSafeArea(.all)
    }
}


struct ForgetPassWordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPassWordView()
    }
}
