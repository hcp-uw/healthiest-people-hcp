
//
//  UserProfileView.swift
//  LockD
//
//  Created by Joy Chang on 2/3/26.
//

import SwiftUI

struct UserProfileView: View {
    var hideFooter: Bool = false

    var headerSection: some View {
        HStack {
            Text("L O C K D")
                .font(.system(size: 24, weight: .black))
                .foregroundColor(.white)
                .shadow(color: Color(red: 0.82, green: 0.60, blue: 0.76).opacity(0.7), radius: 7)

            Spacer()

            HStack(spacing: 20) {
                Image(systemName: "bell.fill")
                Image(systemName: "line.3.horizontal")
            }
            .foregroundColor(.white)
            .font(.system(size: 20))
        }
        .padding(.horizontal, 25)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color(red: 0.12, green: 0.09, blue: 0.14))
    }
    
    var customFooter: some View {
        HStack {
            Spacer()
            Image(systemName: "house.fill")
            Spacer()
            Image(systemName: "trophy")
            Spacer()
            Image(systemName: "person.fill")
            Spacer()
        }
        .padding(.top, 15)
        .padding(.bottom, 30)
        .background(Color(red: 0.12, green: 0.09, blue: 0.14))
        .foregroundColor(.white)
        .font(.system(size: 24))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            ScrollView(.vertical, showsIndicators: false) {
                ZStack() {
                Group {

                    // rectangle that holds name and pfp and progress bar
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 352, height: 288)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.50)
                                .stroke(.white, lineWidth: 0.50)
                        )
                        .offset(x: 0.50, y: -215)
                        .shadow(
                            color: Color(red: 0, green: 0.23, blue: 0.62, opacity: 0.25), radius: 100
                        )
                    
                    // "Day Streak" rectangle
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 105, height: 109)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.50)
                                .stroke(.white, lineWidth: 0.50)
                        )
                        .offset(x: -123, y: 4.50)
                        .shadow(
                            color: Color(red: 0, green: 0.23, blue: 0.62, opacity: 0.25), radius: 100
                        )

                    // "Min/week" rectangle
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 105, height: 109)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.50)
                                .stroke(.white, lineWidth: 0.50)
                        )
                        .offset(x: 124, y: 4.50)
                        .shadow(
                            color: Color(red: 0.67, green: 0.12, blue: 0.99, opacity: 0.25), radius: 100
                        )
                    Text("2310")
                        .font(Font.custom("Instrument Sans", size: 34).weight(.bold))
                        .foregroundColor(.white)
                        .offset(x: 124.50, y: 13.50)

                    // "Times Lockd In" rectangle
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 105, height: 109)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.50)
                                .stroke(.white, lineWidth: 0.50)
                        )
                        .offset(x: 0, y: 4.50)
                        .shadow(
                            color: Color(red: 0.32, green: 0.91, blue: 1, opacity: 0.25), radius: 100
                        )
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.32, green: 0.42, blue: 1))
                            .frame(width: 114, height: 114)
                        
                        Circle()
                            .fill(Color(red: 0.24, green: 0.21, blue: 0.21))
                            .frame(width: 105, height: 105)
                        
                        // Optional: actual profile image
                        Image("profilePic")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 96, height: 96)
                            .clipShape(Circle())
                    }
                    .offset(x: 0.5, y: -280)
                }
                Group {
                    // Progress bar track (background)
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(red: 0.25, green: 0.23, blue: 0.31))
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .inset(by: 0.50)
                                    .stroke(Color(red: 0.22, green: 0.67, blue: 0.93), lineWidth: 0.50)
                            )
                            .frame(width: 290, height: 19)
                        // Fill: 3018/3500 ≈ 86.23%
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(red: 0.96, green: 0.43, blue: 0.22))
                            .frame(width: 290 * (3018.0 / 3500.0), height: 19)
                    }
                    .frame(width: 290, height: 19)
                    .offset(x: -0.50, y: -105.50)
                    // Orange badge behind "LV 12"
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color(red: 0.96, green: 0.43, blue: 0.22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .inset(by: 1)
                                .stroke(.black, lineWidth: 1)
                        )
                        .frame(width: 44, height: 36)
                        .offset(x: 49.50, y: -233)
                    Text("John Smith")
                        .font(Font.custom("Instrument Sans", size: 28).weight(.bold))
                        .foregroundColor(.white)
                        .offset(x: 0, y: -196.50)
                    Text("3018 / 3500 XP")
                        .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
                        .foregroundColor(Color(red: 0.43, green: 1, blue: 0.95))
                        .offset(x: 101, y: -126.50)
                    Text("Level 12")
                        .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
                        .foregroundColor(Color(red: 0.43, green: 1, blue: 0.95))
                        .offset(x: -120.50, y: -126.50)
                    Text("12")
                        .font(Font.custom("Instrument Sans", size: 14).weight(.bold))
                        .foregroundColor(.black)
                        .offset(x: 49.50, y: -227)
                    Text("LV")
                        .font(Font.custom("Instrument Sans", size: 11).weight(.bold))
                        .foregroundColor(.black)
                        .offset(x: 49.50, y: -239)
                }
                Group {
                    Text("67")
                        .font(Font.custom("Instrument Sans", size: 34).weight(.bold))
                        .foregroundColor(.white)
                        .offset(x: 0, y: 13.50)
                    Text("Times Lockd In")
                        .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
                        .foregroundColor(.white)
                        .offset(x: 0, y: 38.50)
                    Text("Min/Week")
                        .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
                        .foregroundColor(.white)
                        .offset(x: 124, y: 38.50)

                    // "productivity warrior" label under name rectangle
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 162, height: 27)
                        .background(Color(red: 0.23, green: 0.07, blue: 0.42))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .inset(by: 0.25)
                                .stroke(Color(red: 0.92, green: 0.59, blue: 1), lineWidth: 0.25)
                        )
                        .offset(x: 0.50, y: -164.50)
                    Text("Productivity Warrior")
                        .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
                        .foregroundColor(Color(red: 0.86, green: 0.69, blue: 0.96))
                        .offset(x: 6, y: -164.50)
                    Text("15")
                        .font(Font.custom("Instrument Sans", size: 34).weight(.bold))
                        .foregroundColor(.white)
                        .offset(x: -122, y: 13.50)
                    Text("Day Streak")
                        .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
                        .foregroundColor(.white)
                        .offset(x: -122, y: 38.50)
                }
                Group {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 45, height: 45)
                        .background(Color(red: 0.50, green: 0.23, blue: 0.27).opacity(0.50))
                        .offset(x: -123, y: -21.50)
                    Text("Your Posts")
                        .font(Font.custom("Inter", size: 20).weight(.semibold))
                        .foregroundColor(.white)
                        .offset(x: -129.50, y: 87)
                }
                Group {
                    // Row 1
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 112, height: 153)
                        .background(Color(red: 0.50, green: 0.23, blue: 0.27).opacity(0.50))
                        .cornerRadius(10)
                        .offset(x: -124.50, y: 183.50)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 153)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: -124, y: 183.50)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 153)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: -1, y: 183.50)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 152)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: 124, y: 183)
                    ZStack() { }
                    .frame(width: 55, height: 55)
                    .offset(x: -125, y: 182.50)
                    ZStack() { }
                    .frame(width: 55, height: 55)
                    .offset(x: -1, y: 182.50)
                    ZStack() { }
                    .frame(width: 55, height: 55)
                    .offset(x: 124, y: 183.50)
                    ZStack() { }
                    .frame(width: 37, height: 37)
                    .offset(x: 124, y: -20.50)
                    ZStack() { }
                    .frame(width: 16, height: 16)
                    .offset(x: -64.50, y: -165)
                    // Row 2
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 153)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: -124, y: 346.50)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 153)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: -1, y: 346.50)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 152)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: 124, y: 346.50)
                    // Row 3
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 153)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: -124, y: 509.50)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 153)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: -1, y: 509.50)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 152)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: 124, y: 509.50)
                    // Row 4
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 153)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: -124, y: 672.50)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 153)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: -1, y: 672.50)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 113, height: 152)
                        .background(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .cornerRadius(10)
                        .offset(x: 124, y: 672.50)
                }
            }
            .frame(minHeight: 900)
            .frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.12, green: 0.09, blue: 0.14).ignoresSafeArea())

            if !hideFooter {
                customFooter
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.12, green: 0.09, blue: 0.14).ignoresSafeArea())
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            UserProfileView()
        }
    }
}