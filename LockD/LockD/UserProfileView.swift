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

    private func postCard(x: CGFloat, y: CGFloat, showAdd: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(showAdd ? Color(red: 0.23, green: 0.07, blue: 0.42) : Color(red: 0.16, green: 0.13, blue: 0.21))
                .frame(width: 113, height: 153)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                )
            if showAdd {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.6))
            } else {
                VStack(spacing: 0) {
                    Spacer()
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                        .frame(height: 8)
                    Text("Post")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                        .frame(height: 12)
                }
            }
        }
        .frame(width: 113, height: 153)
        .offset(x: x, y: y)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            ScrollView(.vertical, showsIndicators: false) {
                ZStack() {
                Group {

                    // rectangle that holds name and pfp and progress bar
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                        )
                        .frame(width: 352, height: 288)
                        .offset(x: 0.50, y: -215)
                    
                    // "Day Streak" rectangle
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                        )
                        .frame(width: 105, height: 109)
                        .offset(x: -123, y: 4.50)

                    // "Min/week" rectangle
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                        )
                        .frame(width: 105, height: 109)
                        .offset(x: 124, y: 4.50)
                    Text("2310")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .offset(x: 124.50, y: 13.50)

                    // "Times Lockd In" rectangle
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.16, green: 0.13, blue: 0.21))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                        )
                        .frame(width: 105, height: 109)
                        .offset(x: 0, y: 4.50)
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
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .offset(x: 0, y: -196.50)
                    Text("3018 / 3500 XP")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.43, green: 1, blue: 0.95))
                        .offset(x: 101, y: -126.50)
                    Text("Level 12")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.43, green: 1, blue: 0.95))
                        .offset(x: -120.50, y: -126.50)
                    Text("12")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .offset(x: 49.50, y: -227)
                    Text("LV")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.black)
                        .offset(x: 49.50, y: -239)
                }
                Group {
                    Text("🔥")
                        .font(.system(size: 22))
                        .offset(x: -122, y: -22)
                    Text("🔒")
                        .font(.system(size: 22))
                        .offset(x: 0, y: -22)
                    Text("⏱️")
                        .font(.system(size: 22))
                        .offset(x: 124, y: -22)
                    Text("67")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .offset(x: 0, y: 13.50)
                    Text("Times Lockd In")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .offset(x: 0, y: 38.50)
                    Text("Min/Week")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .offset(x: 124, y: 38.50)

                    // "productivity warrior" label under name rectangle
                    Capsule()
                        .fill(Color(red: 0.23, green: 0.07, blue: 0.42))
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                        )
                        .frame(width: 162, height: 27)
                        .offset(x: 0.50, y: -164.50)
                    Text("Productivity Warrior")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.86, green: 0.69, blue: 0.96))
                        .offset(x: 6, y: -164.50)
                    Text("15")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .offset(x: -122, y: 13.50)
                    Text("Day Streak")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .offset(x: -122, y: 38.50)
                }
                Group {
                    Text("Your Posts")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .offset(x: -129.50, y: 87)
                }
                Group {
                    // Row 1
                    postCard(x: -124.50, y: 183.50, showAdd: true)
                    postCard(x: -124, y: 183.50, showAdd: false)
                    postCard(x: -1, y: 183.50, showAdd: false)
                    postCard(x: 124, y: 183, showAdd: false)
                    ZStack() { }
                    .frame(width: 37, height: 37)
                    .offset(x: 124, y: -20.50)
                    ZStack() { }
                    .frame(width: 16, height: 16)
                    .offset(x: -64.50, y: -165)
                    // Row 2
                    postCard(x: -124, y: 346.50, showAdd: false)
                    postCard(x: -1, y: 346.50, showAdd: false)
                    postCard(x: 124, y: 346.50, showAdd: false)
                    // Row 3
                    postCard(x: -124, y: 509.50, showAdd: false)
                    postCard(x: -1, y: 509.50, showAdd: false)
                    postCard(x: 124, y: 509.50, showAdd: false)
                    // Row 4
                    postCard(x: -124, y: 672.50, showAdd: false)
                    postCard(x: -1, y: 672.50, showAdd: false)
                    postCard(x: 124, y: 672.50, showAdd: false)
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
