//
//  NotificationView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 16/03/2024.
//

import SwiftUI

struct NotificationView: View {
    @Binding var festivalId: FestivalID
    @State private var currentPage = "notifications"
    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )
            Text("Festival ID : \(festivalId.id)")
            Text("Je suis Notification")
                .navigationBarBackButtonHidden(true)
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}


