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
    private func buildLegendView() -> some View {
        HStack(spacing: 15) {
            ForEach(legendItems, id: \.name) { item in
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(item.color)
                        .frame(width: 10, height: 10)
                    Text(item.name)
                        .font(.system(size: 12))
                }
            }
        }
        .padding()
    }

    private var legendItems: [LegendItem] {
        [
            LegendItem(name: "Accueil", color: Color(red: 0.23529411764705882, green: 0.796078431372549, blue: 0.9568627450980393)),
            LegendItem(name: "Buvette", color: Color(red: 0.06666666666666667, green: 0.4980392156862745, blue: 0.27058823529411763)),
            LegendItem(name: "Animation Jeux", color: Color(red: 0.06274509803921569, green: 0.3607843137254902, blue: 0.6235294117647059)),
            LegendItem(name: "Cuisine", color: Color(red: 0.2, green: 0.7686274509803922, blue: 0.5058823529411764)),
            LegendItem(name: "Flexible", color: Color(red: 0.9921568627450981, green: 0.30980392156862746, blue: 0.30980392156862746))
        ]
    }

    struct LegendItem: Identifiable {
        let id = UUID()
        let name: String
        let color: Color
    }
  private func getDayViewWidth(festival: Festival) -> CGFloat {
         let screenWidth = UIScreen.main.bounds.width
         let numberOfDays = CGFloat(festival.dureeFestival())

         if numberOfDays <= 3 {
             return screenWidth / 3
         } else {
             return screenWidth / 3
         }
     }
    
    var gradient: LinearGradient {
            LinearGradient(gradient: Gradient(colors: [.white, Color(.sRGB, white: 0.95, opacity: 1)]), startPoint: .top, endPoint: .bottom)
        }
    

    var body: some View {
        VStack {
            HeaderView(selectedFestivalId: $festivalId, currentPage: $currentPage)

            if let festival = viewModel.state.festival {
                Text(festival.nomFestival)
                    .font(.largeTitle)
                VStack {
                HStack(spacing: 0) {
                    buildDaysView(for: festival)
                }
                HStack {
                    buildLegendView()
                }
                }
                .frame(maxWidth: 400, maxHeight: 450)
                
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
        .onAppear {
                    viewModel.send(intent: .fetchFestivalData)
                  }
    }

}


