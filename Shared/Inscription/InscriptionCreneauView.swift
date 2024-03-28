//
//  InscriptionCreneauView.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 25/03/2024.
//

import SwiftUI


struct InscriptionCreneauView: View {
    @Binding var festivalId: FestivalID
    @ObservedObject var viewModel: InscriptionViewModel
    @State private var currentPage = "inscription"
  
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
  
    private func getDayViewWidth(festival: Festival) -> CGFloat {
           let screenWidth = UIScreen.main.bounds.width
           let numberOfDays = CGFloat(festival.dureeFestival())

           if numberOfDays <= 3 {
               return screenWidth / 3
           } else {
               return screenWidth / 3
           }
       }
    
    private func buildDaysView(for festival: Festival) -> some View {
          ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 0) {
                  ForEach(0..<festival.dureeFestival(), id: \.self) { index in
                      buildDayView(for: festival, index: index)
                          .frame(width: getDayViewWidth(festival: festival))
                  }
              }
          }
      }

    private func buildDayView(for festival: Festival, index: Int) -> some View {
        let date = Calendar.current.date(byAdding: .day, value: index, to: festival.dateDebut)!
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayName = formatter.string(from: date).capitalized

        return VStack(alignment: .leading, spacing: 8) {
            Text(dayName)
                .font(.headline)
                .minimumScaleFactor(0.5) // Ajoutez cette ligne pour permettre au texte de réduire sa taille si nécessaire
                .lineLimit(1) // Ajoutez cette ligne pour limiter le texte à une seule ligne
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 36)
            buildTimeSlotsView(for: festival, index: index)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 26)
    }


    private func buildTimeSlotsView(for festival: Festival, index: Int) -> some View {
        let date = Calendar.current.date(byAdding: .day, value: index, to: festival.dateDebut)!
        return Group {
            ForEach(Array(zip(viewModel.timeSlots.indices, viewModel.timeSlots)), id: \.0) { index, timeSlot in
                buildTimeSlotView(timeSlot: timeSlot, date: date)
            }
        }
    }


      private func buildTimeSlotView(timeSlot: String, date: Date) -> AnyView {
          let isAlreadyRegistered = viewModel.isUserAlreadyRegistered(timeSlot: timeSlot, date: date)

          // Vérifier si selectedPosition a une valeur
          if let selectedPosition = viewModel.selectedPosition {
              // Obtenir le nombre d'inscriptions pour cette heure, ce jour et ce poste
              let inscriptionCount = viewModel.getInscriptionCount(timeSlot: timeSlot, date: date, postId: selectedPosition.idPoste)

              let timeSlotView = VStack(alignment: .leading, spacing: 4) {
                  Text(timeSlot)
                      .font(isAlreadyRegistered ? .subheadline.italic() : .subheadline)
                      .foregroundColor(isAlreadyRegistered ? .gray : .primary)
                      .frame(maxWidth: .infinity, alignment: .center)
                      .overlay(
                          RoundedRectangle(cornerRadius: 10)
                              .stroke(Color.gray, lineWidth: 0)
                              .frame(height: 40)
                      )
                      .padding(.bottom, 6)
                      .contentShape(Rectangle()) // Ajoute une forme de contenu pour rendre le texte cliquable
                      .onTapGesture {
                          if !isAlreadyRegistered {
                              viewModel.postInscription(timeSlot: timeSlot, date: date) { result in
                                  switch result {
                                  case .success:
                                      alertMessage = "Inscription réussie !"
                                      showAlert = true
                                  case .failure(let error):
                                      alertMessage = "Erreur lors de l'inscription : \(error.localizedDescription)"
                                      showAlert = true
                                  }
                              }
                          }
                      }

                  // Ajouter une jauge ici
                  if let count = inscriptionCount, let capacity = selectedPosition.capacite {
                      ProgressView(value: Double(count) / Double(capacity))
                          .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                          .frame(width: 70, height: 10)
                          .padding(.bottom, 30)
                  }
              }

              return AnyView(timeSlotView)
          } else {
              // Afficher uniquement le Text si selectedPosition est nil
              let timeSlotView = Text(timeSlot)
                  .font(isAlreadyRegistered ? .subheadline.italic() : .subheadline)
                  .foregroundColor(isAlreadyRegistered ? .gray : .primary)
                  .frame(maxWidth: .infinity, alignment: .center)
                  .overlay(
                      RoundedRectangle(cornerRadius: 10)
                          .stroke(Color.gray, lineWidth: 0)
                          .frame(height: 40)
                  )
                  .padding(.bottom, 36)
                  .contentShape(Rectangle()) // Ajoute une forme de contenu pour rendre le texte cliquable
                  .onTapGesture {
                      if !isAlreadyRegistered {
                          viewModel.postInscription(timeSlot: timeSlot, date: date) { result in
                              switch result {
                              case .success:
                                  alertMessage = "Inscription réussie !"
                                  showAlert = true
                              case .failure(let error):
                                  alertMessage = "Erreur lors de l'inscription : \(error.localizedDescription)"
                                  showAlert = true
                              }
                          }
                      }
                  }

              return AnyView(timeSlotView)
          }
      }





        var body: some View {
          VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )
            
              if let festival = viewModel.state.festival! {
                  buildDaysView(for: festival)
              } else {
                  ProgressView()
              }
            Spacer()
            }
          .alert(isPresented: $showAlert) {
              Alert(title: Text("Inscription"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
          }
          .edgesIgnoringSafeArea(.top)
          
        }
}

