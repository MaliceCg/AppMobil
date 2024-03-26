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
            ForEach(Array(zip(viewModel.timeSlots.indices, viewModel.timeSlots)), id: \.0) { index, timeSlot in
                buildTimeSlotView(timeSlot: timeSlot)
            }
        }


        private func buildTimeSlotView(timeSlot: String) -> some View {
            Text(timeSlot)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 0)
                        .frame(height: 40)
                )
                .padding(.bottom, 36)
        }


        var body: some View {
          VStack {
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )
            
            if let festival = viewModel.festival {
                  buildDaysView(for: festival)
              } else {
                  Text("Chargement...")
              }
              
            }
        }
}

