//
//  TabBarView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 16/03/2024.
//

// TabBarView.swift
import SwiftUI

struct TabBarView: View {
    @State var festivalId: FestivalID
    @State var festival: Festival
    @State private var isInscriptionCreneauViewActive = false
    @State private var selectedTab = Tab.dashboard

    var body: some View {
        TabView(selection: $selectedTab) {
            NotificationView(festivalId: $festivalId, viewModel: NotificationViewModel(idFestival: festivalId))
                .tag(Tab.notifications)
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }

            PlanningView(festivalId: $festivalId, viewModel: PlanningViewModel(idFestival: festivalId))
                .tag(Tab.planning)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Planning")
                }

            DashboardView(selectedFestivalId: $festivalId)
                .tag(Tab.dashboard)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            InscriptionView(festivalId: $festivalId, viewModel: InscriptionViewModel(idFestival: festivalId, festival: festival), isInscriptionCreneauViewActive: $isInscriptionCreneauViewActive)
                .tag(Tab.inscription)
                .tabItem {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("Inscription")
                }

            ActivitesView(festivalId: $festivalId, viewModel: ActiviteViewModel())
                .tag(Tab.activites)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Activités")
                }
        }
    }
}
