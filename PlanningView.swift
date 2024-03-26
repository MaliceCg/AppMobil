//
//  PlanningView.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 14/03/2024.
//

import SwiftUI


struct PlanningView: View {
    @Binding var festivalId: FestivalID
    
    
    @ObservedObject var viewModel: PlanningViewModel
  
    @State private var currentPage = "planning"
  
  

    
      private func buildDaysView(for festival: Festival) -> some View {
          ForEach(0..<festival.dureeFestival(), id: \.self) { index in
              buildDayView(for: festival, index: index)
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
                  .frame(maxWidth: .infinity, alignment: .center)
                  .padding(.bottom, 36)
              buildTimeSlotsView(for: festival, index: index)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .padding(.horizontal, 8)
      }

      private func buildTimeSlotsView(for festival: Festival, index: Int) -> some View {
          ForEach(Array(zip(viewModel.state.timeSlots, viewModel.inscriptionColors[index])), id: \.0) { timeSlot, inscriptionColor in
              buildTimeSlotView(timeSlot: timeSlot, inscriptionColor: inscriptionColor)
          }
      }

      private func buildTimeSlotView(timeSlot: String, inscriptionColor: Color?) -> some View {
          Text(timeSlot)
              .font(.subheadline)
              .frame(maxWidth: .infinity, alignment: .center)
              .background(
                  RoundedRectangle(cornerRadius: 10)
                      .fill(inscriptionColor ?? Color.clear)
                      .frame(height: 40)
              )
              .overlay(
                  RoundedRectangle(cornerRadius: 10)
                      .stroke(Color.gray, lineWidth: 0)
                      .frame(height: 40)
              )
              .padding(.bottom, 36)
      }
   
    
    var gradient: LinearGradient {
            LinearGradient(gradient: Gradient(colors: [.white, Color(.sRGB, white: 0.95, opacity: 1)]), startPoint: .top, endPoint: .bottom)
        }
    
    var body: some View {
      
        VStack {
          
            HeaderView(selectedFestivalId: $festivalId,currentPage: $currentPage )
            
            if let festival = viewModel.state.festival {
                Text(festival.nomFestival)
                    .font(.largeTitle)
                HStack(spacing: 0) {
                    buildDaysView(for: festival)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: 350, maxHeight: 400)
                .padding(.horizontal, 16)
                .background(
                    gradient
                        .cornerRadius(16)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
               
            } else {
               ProgressView()
            }
          
            Spacer()
          
        }
        .background(Color(red: 0.8588, green: 0.8588, blue: 0.8588, opacity: 1.0))
        .edgesIgnoringSafeArea(.top)
      
    }
   
    
}






