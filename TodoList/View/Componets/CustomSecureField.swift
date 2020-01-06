//
//  CustomSecureField.swift
//  SwiftUISignin
//
//  Created by Gerald Brigen on 12/31/19.
//  Copyright © 2019 Gerald Brigen. All rights reserved.
//

import SwiftUI

// 存储密码
struct CustomSecureField: View {
    var placeholder : Text
    @Binding var password: String
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading){
            // 没有输入password之前，用占位符
            if password.isEmpty {
                placeholder
            }
            SecureField("", text: $password, onCommit: commit)
                .foregroundColor(.white)
        }
    }
}

struct CustomSecureField_Previews: PreviewProvider {
    static var previews: some View {
        CustomSecureField(placeholder: Text("www"), password: .constant("232131"))
    }
}

