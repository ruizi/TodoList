//
// Created by 尹毓康 on 2020/1/8.
// Copyright (c) 2020 yukangyin. All rights reserved.
//

import SwiftUI
import Combine

struct Toast<Presenting>: View where Presenting: View {

    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text
    // 隔多少秒后消失
//    @State var disappearAfter: Int = 2

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.presenting()
                        .blur(radius: self.isShowing ? 1 : 0)
                VStack {
                    self.text
                }
                        .frame(width: geometry.size.width / 2,
                                height: geometry.size.height / 12)
                        .background(Color.secondary.colorInvert())
                        .foregroundColor(Color.primary)
                        .cornerRadius(20)
                        .transition(.slide)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {// toast出现3秒后消失
                                withAnimation {
                                    self.isShowing = false
                                }
                            }
                        }
                        .opacity(self.isShowing ? 1 : 0)
                        .offset(y: self.isShowing ? UIScreen.main.bounds.height / 3 : UIScreen.main.bounds.height)
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing,
                presenting: { self },
                text: text)
    }
}
