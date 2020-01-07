//
//  AlertView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/7.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI


struct AlertView: View {
    @State private var showingAlert = false
    var body: some View {
        Button(action: {
            self.showingAlert = true
        }) {
            Text("Show Alert")
        }
        .alert(isPresented:$showingAlert) {
            Alert(title: Text("SwiftUI 警告框"), message: Text("很容易吧"), primaryButton: .default(Text("是的")) {
                    print("Yeah")
            }, secondaryButton: .destructive(Text("取消")))
        }
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertView()
//    }
//}
