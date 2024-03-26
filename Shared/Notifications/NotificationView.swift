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
    @ObservedObject var viewModel: NotificationViewModel

    init(festivalId: Binding<FestivalID>, viewModel: NotificationViewModel) {
        self._festivalId = festivalId
        self.viewModel = viewModel
        self.viewModel.idFestival = festivalId.wrappedValue
    }

    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId, currentPage: $currentPage)
           
            if viewModel.state.loading {
                ProgressView()
            } else {
                VStack {
                    if let soiréeDécouverteNotifs = viewModel.state.listNotif.filter({ $0.Typee == "Soirée Découverte" }),
                       !soiréeDécouverteNotifs.isEmpty {
                        Text("Soirée Découverte")
                            .font(.headline)
                        ForEach(soiréeDécouverteNotifs, id: \.idNotif) { notif in
                            NotificationBubbleView(notif: notif)
                        }
                    }

                    Text("Notifications")
                        .font(.headline)

                    ForEach(viewModel.state.listNotif.filter({ $0.Typee != "Soirée Découverte" }), id: \.idNotif) { notif in
                        NotificationBubbleView(notif: notif)
                    }
                }
            }
            Spacer()
        }
        .background(Color(red: 0.8588, green: 0.8588, blue: 0.8588, opacity: 1.0))
        .edgesIgnoringSafeArea(.top)
    }
}

struct NotificationBubbleView: View {
    let notif: Notifications

    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [.white, Color(.sRGB, white: 0.95, opacity: 1)]), startPoint: .top, endPoint: .bottom)
    }

    var body: some View {
        HStack {
            Text(notif.TexteNotification)
                .padding()
                .background(
                    gradient
                        .cornerRadius(16)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
            Spacer()
        }
    }
}
