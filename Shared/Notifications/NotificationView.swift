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
            Text("Festival ID : \(festivalId.id)")
            if viewModel.state.loading {
                ProgressView()
            } else {
                VStack {
                    if let soiréeDécouverteNotifs = viewModel.state.listNotif.filter({ $0.Typee == "Soirée Découverte" }),
                       !soiréeDécouverteNotifs.isEmpty {
                        Text("Soirée Découverte")
                            .font(.headline)
                        ForEach(soiréeDécouverteNotifs, id: \.idNotif) { notif in
                            NotificationRowView(notif: notif)
                        }
                    }

                    Text("Notifications")
                        .font(.headline)

                    ForEach(viewModel.state.listNotif.filter({ $0.Typee != "Soirée Découverte" }), id: \.idNotif) { notif in
                        NotificationRowView(notif: notif)
                    }
                }
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct NotificationRowView: View {
    let notif: Notifications

    var body: some View {
        HStack {
            Text(notif.TexteNotification)
            Spacer()

        }
    }
}
