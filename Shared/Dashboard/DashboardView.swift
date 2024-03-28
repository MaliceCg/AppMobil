//  DashboardView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 15/03/2024.
//

import SwiftUI

struct DashboardView: View {
    @Binding var selectedFestivalId: FestivalID
    @State private var currentPage = "dashboard"
    @State private var isProfileViewActive = false


    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $selectedFestivalId, currentPage: $currentPage)
                .navigationBarBackButtonHidden(true)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Button(action: {
                        self.isProfileViewActive = true
                    }) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Profil")
                                .font(.headline)
                            Text("Modifiez vos informations personnelles et gérez vos préférences.")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $isProfileViewActive) {
                        ProfileView(viewModel: ProfileViewModel())
                    }

                    Text("Découvrez les fonctionnalités de l'application :")
                        .font(.headline)
                        .padding(.vertical, 10)

                    VStack(alignment: .leading, spacing: 10) {
                        SectionView(title: "Notifications", imageName: "bell", description: "Recevez des notifications importantes sur le festival et vos créneaux.")

                        SectionView(title: "Planning", imageName: "calendar", description: "Consultez votre planning personnalisé et les créneaux auxquels vous êtes inscrit.")

                        SectionView(title: "Inscription", imageName: "person.crop.circle.badge.plus", description: "Inscrivez-vous aux créneaux disponibles et gérez vos inscriptions.")

                        SectionView(title: "Activités", imageName: "gamecontroller", description: "Découvrez les activités proposées lors du festival et consultez les détails.")
                    }
                    .padding(.horizontal)
                }
                .padding()
            }

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct SectionView: View {
    let title: String
    let imageName: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: imageName)
                    .font(.title)
                Text(title)
                    .font(.headline)
            }
            Text(description)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
