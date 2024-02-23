//
//  homePage.swift
//  Sudoku_solver
//
//  Created by Menno Konijn on 23/01/2024.
//

import Foundation
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        // Navigation view to navigate between pages
        NavigationView {
            ZStack {
                themeManager.isDarkMode ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all)
                VStack {
                    header
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                    Spacer()
                    NavigationLink(destination: SudokuView()) {
                        Text("Solve a Sudoku")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(minWidth: 200)
                            .foregroundColor(themeManager.isDarkMode ? Color.white : Color.black)
                            .padding()
                            .background(themeManager.isDarkMode ? Color.black : Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                    .padding(.bottom, 16)
                    Text(themeManager.isDarkMode ? "Lightmode" : "Darkmode")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(minWidth: 200)
                        .foregroundColor(themeManager.isDarkMode ? Color.white : Color.black)
                        .padding()
                        .background(themeManager.isDarkMode ? Color.black : Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(themeManager.isDarkMode ? Color.white : Color.black, lineWidth: 2)
                        )
                        .onTapGesture {
                            themeManager.toggleTheme() // Toggle the theme on tap
                        }
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 64)
            }
        }
    }
    
    private var header: some View {
        VStack {
            Text("Sudoku Solver")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(themeManager.isDarkMode ? Color.white : Color.black)
        }
    }
}
