//
//  UserProfileView.swift
//  LockD
//
//  Created by Joy Chang on 2/3/26.
//

import SwiftUI

struct UserProfileView: View {
  var body: some View {
    ZStack() {
      Group {
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
          .offset(x: 0.50, y: -135)
          .shadow(
            color: Color(red: 0, green: 0.23, blue: 0.62, opacity: 0.25), radius: 100
          )
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
          .offset(x: -123, y: 84.50)
          .shadow(
            color: Color(red: 1, green: 0.23, blue: 0.95, opacity: 0.25), radius: 100
          )
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
          .offset(x: 124, y: 84.50)
          .shadow(
            color: Color(red: 0.67, green: 0.12, blue: 0.99, opacity: 0.25), radius: 100
          )
        Text("2310")
          .font(Font.custom("Instrument Sans", size: 34).weight(.bold))
          .foregroundColor(.white)
          .offset(x: 124.50, y: 93.50)
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
          .offset(x: 0, y: 84.50)
          .shadow(
            color: Color(red: 0.32, green: 0.91, blue: 1, opacity: 0.25), radius: 100
          )
        Ellipse()
          .foregroundColor(.clear)
          .frame(width: 114, height: 114)
          .background(Color(red: 0.32, green: 0.42, blue: 1))
          .offset(x: 0.50, y: -200)
        Ellipse()
          .foregroundColor(.clear)
          .frame(width: 105, height: 105)
          .background(Color(red: 0.24, green: 0.21, blue: 0.21))
          .offset(x: 0, y: -200.50)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 32, height: 36)
          .background(Color(red: 1, green: 0.70, blue: 0.28))
          .cornerRadius(7)
          .overlay(
            RoundedRectangle(cornerRadius: 7)
              .inset(by: 1)
              .stroke(.black, lineWidth: 1)
          )
          .offset(x: 50.50, y: -153)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 32, height: 36)
          .background(Color(red: 0.96, green: 0.43, blue: 0.22))
          .cornerRadius(7)
          .overlay(
            RoundedRectangle(cornerRadius: 7)
              .inset(by: 1)
              .stroke(.black, lineWidth: 1)
          )
          .offset(x: 83.50, y: -153)
        ZStack() {

        }
        .frame(width: 24, height: 24)
        .offset(x: 83.50, y: -153)
        .shadow(
          color: Color(red: 1, green: 1, blue: 1, opacity: 0.39), radius: 8.20
        )
      };
        Group {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 290, height: 19)
          .background(Color(red: 0.25, green: 0.23, blue: 0.31))
          .cornerRadius(30)
          .overlay(
            RoundedRectangle(cornerRadius: 30)
              .inset(by: 0.50)
              .stroke(Color(red: 0.22, green: 0.67, blue: 0.93), lineWidth: 0.50)
          )
          .offset(x: -0.50, y: -25.50)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 240, height: 17)
          .background(Color(red: 0.84, green: 0.60, blue: 1))
          .cornerRadius(30)
          .offset(x: -25.50, y: -25.50)
        Text("John Smith")
          .font(Font.custom("Instrument Sans", size: 28).weight(.bold))
          .foregroundColor(.white)
          .offset(x: 0, y: -116.50)
        Text("3018 / 3500 XP")
          .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
          .foregroundColor(Color(red: 0.43, green: 1, blue: 0.95))
          .offset(x: 101, y: -46.50)
        Text("Level 12")
          .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
          .foregroundColor(Color(red: 0.43, green: 1, blue: 0.95))
          .offset(x: -120.50, y: -46.50)
        Text("12")
          .font(Font.custom("Instrument Sans", size: 14).weight(.bold))
          .foregroundColor(.black)
          .offset(x: 49.50, y: -147)
        Text("LV")
          .font(Font.custom("Instrument Sans", size: 11).weight(.bold))
          .foregroundColor(.black)
          .offset(x: 49.50, y: -159)
        HStack(alignment: .bottom, spacing: 1) {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 9, height: 23)
            .cornerRadius(1)
            .overlay(
              RoundedRectangle(cornerRadius: 1)
                .inset(by: 1)
                .stroke(Color(red: 0.87, green: 0.84, blue: 0.88), lineWidth: 1)
            )
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 9, height: 35)
            .cornerRadius(1)
            .overlay(
              RoundedRectangle(cornerRadius: 1)
                .inset(by: 1)
                .stroke(Color(red: 0.87, green: 0.84, blue: 0.88), lineWidth: 1)
            )
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 9, height: 17)
            .cornerRadius(1)
            .overlay(
              RoundedRectangle(cornerRadius: 1)
                .inset(by: 1)
                .stroke(Color(red: 0.87, green: 0.84, blue: 0.88), lineWidth: 1)
            )
        }
        .frame(width: 29, height: 35)
        .offset(x: 46.50, y: 388.50)
        ZStack() {

        }
        .frame(width: 37.50, height: 37.50)
        .offset(x: -42.75, y: 388.75)
        ZStack() {

        }
        .frame(width: 36, height: 36)
        .offset(x: -135.50, y: 389)
      };
        Group {
        ZStack() {

        }
        .frame(width: 27, height: 27)
        .offset(x: 134.50, y: 393.50)
        .shadow(
          color: Color(red: 0.91, green: 0.50, blue: 0.84, opacity: 0.69), radius: 17.40
        )
        Rectangle()
          .foregroundColor(.clear)
          .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
          .frame(width: 38, height: 38)
          .cornerRadius(18)
          .overlay(
            RoundedRectangle(cornerRadius: 18)
              .inset(by: 1.25)
              .stroke(Color(red: 0.82, green: 0.60, blue: 0.76), lineWidth: 1.25)
          )
          .offset(x: 135, y: 389)
          .shadow(
            color: Color(red: 0.91, green: 0.50, blue: 0.84, opacity: 0.69), radius: 17.40
          )
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 385, height: 0)
          .overlay(
            Rectangle()
              .stroke(
                Color(red: 1, green: 1, blue: 1).opacity(0.09), lineWidth: 0.50
              )
          )
          .offset(x: 0, y: 347.03)
        Text("67")
          .font(Font.custom("Instrument Sans", size: 34).weight(.bold))
          .foregroundColor(.white)
          .offset(x: 0, y: 93.50)
        Text("Times Lockd In")
          .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
          .foregroundColor(.white)
          .offset(x: 0, y: 118.50)
        Text("Min/Week")
          .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
          .foregroundColor(.white)
          .offset(x: 124, y: 118.50)
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
          .offset(x: 0.50, y: -84.50)
        Text("Productivity Warrior")
          .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
          .foregroundColor(Color(red: 0.86, green: 0.69, blue: 0.96))
          .offset(x: 6, y: -84.50)
        Text("15")
          .font(Font.custom("Instrument Sans", size: 34).weight(.bold))
          .foregroundColor(.white)
          .offset(x: -122, y: 93.50)
        Text("Day Streak")
          .font(Font.custom("Instrument Sans", size: 12).weight(.bold))
          .foregroundColor(.white)
          .offset(x: -122, y: 118.50)
    };
        Group {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 385, height: 0)
          .overlay(
            Rectangle()
              .stroke(
                Color(red: 1, green: 1, blue: 1).opacity(0.09), lineWidth: 0.50
              )
          )
          .offset(x: 0, y: -313.97)
        Text("L     CKD")
          .font(Font.custom("Instrument Sans", size: 26).weight(.bold))
          .italic()
          .foregroundColor(Color(red: 0.82, green: 0.60, blue: 0.76))
          .shadow(color: Color(red: 0.91, green: 0.50, blue: 0.84, opacity: 0.52), radius: 7, x: 0, y: 0)
          .offset(x: 0.50, y: -343.50)
        ZStack() {

        }
        .frame(width: 22.67, height: 16)
        .offset(x: 145.83, y: -402)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 45, height: 45)
          .background(Color(red: 0.50, green: 0.23, blue: 0.27).opacity(0.50))
          .offset(x: -123, y: 58.50)
        Text("Your Posts")
          .font(Font.custom("Inter", size: 20).weight(.semibold))
          .foregroundColor(.white)
          .offset(x: -129.50, y: 167)
    };
        Group {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 112, height: 153)
          .background(Color(red: 0.50, green: 0.23, blue: 0.27).opacity(0.50))
          .cornerRadius(10)
          .offset(x: -124.50, y: 263.50)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 113, height: 153)
          .background(Color(red: 0.16, green: 0.13, blue: 0.21))
          .cornerRadius(10)
          .offset(x: -124, y: 263.50)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 113, height: 153)
          .background(Color(red: 0.16, green: 0.13, blue: 0.21))
          .cornerRadius(10)
          .offset(x: -1, y: 263.50)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 113, height: 152)
          .background(Color(red: 0.16, green: 0.13, blue: 0.21))
          .cornerRadius(10)
          .offset(x: 124, y: 263)
        ZStack() {

        }
        .frame(width: 55, height: 55)
        .offset(x: -125, y: 262.50)
        ZStack() {

        }
        .frame(width: 55, height: 55)
        .offset(x: -1, y: 262.50)
        ZStack() {

        }
        .frame(width: 55, height: 55)
        .offset(x: 124, y: 263.50)
        ZStack() {

        }
        .frame(width: 37, height: 37)
        .offset(x: 124, y: 59.50)
        ZStack() {

        }
        .frame(width: 16, height: 16)
        .offset(x: -64.50, y: -85)
      }
    }
    .frame(width: 393, height: 852)
    .background(Color(red: 0.12, green: 0.09, blue: 0.14));
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
