//
//  CalendarView.swift
//  TodoList
//
//  Created by 尹毓康 on 2020/1/7.
//  Copyright © 2020 yukangyin. All rights reserved.
//

import SwiftUI

struct CalendarView: View {
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    @State var monthOffset = 0
    
    var body: some View {
        RKViewController(isPresented: true, rkManager: self.rkManager1, monthOffset: self.monthOffset)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
