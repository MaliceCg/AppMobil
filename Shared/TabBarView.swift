//
//  TabBarView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 16/03/2024.
//

import SwiftUI
struct TabBarView: View {
    @State var festivalId: FestivalID

    var body: some View {
        TabView {
            
            NotificationView(festivalId: $festivalId, viewModel: NotificationViewModel(idFestival: festivalId))
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
          PlanningView(festivalId: $festivalId, viewModel: PlanningViewModel(idFestival: festivalId))
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Planning")
                }
            DashboardView(selectedFestivalId: $festivalId)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            InscriptionView(festivalId: $festivalId)
                .tabItem {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("Inscription")
                }
            ActivitesView(festivalId: $festivalId)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Activités")
                }
        }
    }
}
