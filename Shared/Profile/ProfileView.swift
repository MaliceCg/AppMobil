//
//  ProfileView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 27/03/2024.
//

import SwiftUI
import Foundation
struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var currentPage = "profile"
    @State private var showEditForm = false
    @State private var editedPseudo = ""
    @State private var editedPrenom = ""
    @State private var editedNom = ""
    @State private var editedEmail = ""
    @State private var editedTelephone = ""
    @State private var editedAdresse = ""
    @State private var editedVille = ""
    @State private var editedRegime = ""
    @State private var editedTailletTShirt = ""
    @State private var editedStatutHebergement = ""
    @State private var showSaveButton = false

    var body: some View {
        VStack {
            if viewModel.state.loading {
                ProgressView()
            } else {
                List {
                    Section(header: Text("Informations personnelles")) {
                        HStack {
                            Text("Pseudo:")
                            Spacer()
                            TextField(editedPseudo, text: $editedPseudo)
                                .onChange(of: editedPseudo) { _ in
                                    showSaveButton = true
                                }
                        }
                        HStack {
                            Text("Prénom:")
                            Spacer()
                            TextField(editedPrenom, text: $editedPrenom)
                                .onChange(of: editedPrenom) { _ in
                                    showSaveButton = true
                                }
                        }
                        HStack {
                            Text("Nom:")
                            Spacer()
                            TextField(editedNom, text: $editedNom)
                                .onChange(of: editedNom) { _ in
                                    showSaveButton = true
                                }
                        }
                    }
                    Section(header: Text("Informations de contact")) {
                        HStack {
                            Text("Email:")
                            Spacer()
                            TextField(editedEmail, text: $editedEmail)
                                .onChange(of: editedEmail) { _ in
                                    showSaveButton = true
                                }
                        }
                        HStack {
                            Text("Téléphone:")
                            Spacer()
                            TextField(editedTelephone, text: $editedTelephone)
                                .onChange(of: editedTelephone) { _ in
                                    showSaveButton = true
                                }
                        }
                        HStack {
                            Text("Adresse:")
                            Spacer()
                            TextField(editedAdresse, text: $editedAdresse)
                                .onChange(of: editedAdresse) { _ in
                                    showSaveButton = true
                                }
                        }
                        HStack {
                            Text("Ville:")
                            Spacer()
                            TextField(editedVille, text: $editedVille)
                                .onChange(of: editedVille) { _ in
                                    showSaveButton = true
                                }
                        }
                    }
                    Section(header: Text("Préférences")) {
                        HStack {
                            Text("Régime Alimentaire:")
                            Spacer()
                            TextField(editedRegime, text: $editedRegime)
                                .onChange(of: editedRegime) { _ in
                                    showSaveButton = true
                                }
                        }
                        HStack {
                            Text("Taille T-Shirt:")
                            Spacer()
                            TextField(editedTailletTShirt, text: $editedTailletTShirt)
                                .onChange(of: editedTailletTShirt) { _ in
                                    showSaveButton = true
                                }
                        }
                        HStack {
                            Text("Logement:")
                            Spacer()
                            TextField(editedStatutHebergement, text: $editedStatutHebergement)
                                .onChange(of: editedStatutHebergement) { _ in
                                    showSaveButton = true
                                }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Profil")
                .navigationBarItems(trailing: Button(action: {
                    viewModel.sendIntent(intent: .logout)
                }) {
                    Text("Déconnexion")
                })
                .onAppear {
                    if !viewModel.didFetchUserData {
                        viewModel.sendIntent(intent: .fetchUserData)
                    }
                    if let userData = viewModel.state.userData {
                        editedPseudo = userData.Pseudo ?? ""
                        editedPrenom = userData.Prenom ?? ""
                        editedNom = userData.Nom ?? ""
                        editedEmail = userData.Email ?? ""
                        editedTelephone = userData.Telephone ?? ""
                        editedAdresse = userData.Adresse ?? ""
                        editedVille = userData.Ville ?? ""
                        editedRegime = userData.Regime ?? ""
                        editedTailletTShirt = userData.TailletTShirt ?? ""
                        editedStatutHebergement = userData.StatutHebergement ?? ""
                    }
                }


                if showSaveButton {
                    Button(action: {
                        let editedInfo: [String: Any] = [
                            "Pseudo": editedPseudo,
                            "Prenom": editedPrenom,
                            "Nom": editedNom,
                            "Email": editedEmail,
                            "Telephone": editedTelephone,
                            "Adresse": editedAdresse,
                            "Ville": editedVille,
                            "Regime": editedRegime,
                            "TailletTShirt": editedTailletTShirt,
                            "StatutHebergement": editedStatutHebergement
                        ]

                        viewModel.sendIntent(intent: .updateUserData(editedInfo))

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Attendez un court instant avant de récupérer les données de l'utilisateur
                            if self.viewModel.isUpdateCompleted { // Vérifiez si la mise à jour est terminée
                                self.viewModel.sendIntent(intent: .fetchUserData) // Fetch user data again
                                editedPseudo = viewModel.state.userData?.Pseudo ?? ""
                                editedPrenom = viewModel.state.userData?.Prenom ?? ""
                                editedNom = viewModel.state.userData?.Nom ?? ""
                                editedEmail = viewModel.state.userData?.Email ?? ""
                                editedTelephone = viewModel.state.userData?.Telephone ?? ""
                                editedAdresse = viewModel.state.userData?.Adresse ?? ""
                                editedVille = viewModel.state.userData?.Ville ?? ""
                                editedRegime = viewModel.state.userData?.Regime ?? ""
                                editedTailletTShirt = viewModel.state.userData?.TailletTShirt ?? ""
                                editedStatutHebergement = viewModel.state.userData?.StatutHebergement ?? ""
                                showSaveButton = false
                                self.viewModel.isUpdateCompleted = false // Réinitialisez la variable
                            }
                        }
                    }) {
                        Text("Sauvegarder")
                    }
                    .padding()
                }



            }
        }
    }
}
