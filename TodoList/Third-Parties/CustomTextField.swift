//
//  CustomPlaceholder.swift
//  SwiftUISignin
//
//  Created by Gerald Brigen on 12/31/19.
//  Copyright © 2019 Gerald Brigen. All rights reserved.
//

import SwiftUI

// 存储非密码的内容：邮箱，用户名等
struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String // 存储非密码的内容
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit).foregroundColor(Color.white)
        }
    }
}

