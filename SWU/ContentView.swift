//
//  ContentView.swift
//  SWU
//
//  Created by Scott Ha on 2/29/24.
//

import SwiftUI
import Foundation

func getTimestamp () -> String {
  let date = Date()
  let calendar = Calendar.current

  let hour = calendar.component(.hour, from: date)
  let minute = calendar.component(.minute, from: date)
  let second = calendar.component(.second, from: date)

  return "[\(hour % 12 == 0 ? 12 : hour % 12):\(minute):\(second)]"
}

struct ContentView: View {
  @State private var showConfirmation = false
  @State private var showingLog = false

  @State var player1damage: Int = 0
  @State var player1leader: Bool = false
  @State var player1base: Bool = false
  @State var player1initiative: Bool = true
  
  @State var player2damage: Int = 0
  @State var player2leader: Bool = false
  @State var player2base: Bool = false
  @State var player2initiative: Bool = false
  
  @State var audit: [String] = []
  
  func handleDamage (player: Int, damage: Int) {
    var finalDamage = 0
    if player == 1 {
      if player1damage == 0 && damage < 0 {
        return
      }
      player1damage += damage
      if player1damage < 0 {
        player1damage = 0
      }
      finalDamage = player1damage
    } else {
      if player2damage == 0 && damage < 0 {
        return
      }
      player2damage += damage
      if player2damage < 0 {
        player2damage = 0
      }
      finalDamage = player2damage
    }
    
    let verbage = damage > 0 ? "took" : "healed"
    let timestamp = getTimestamp()
    
    audit.append("\(timestamp): Player \(player) \(verbage) \(abs(damage)); final result: \(finalDamage)")
  }

  func getDamageColor (damage: Int) -> Color {
    if damage < 5 {
      return .green
    } else if damage < 10 {
      return .yellow
    } else if damage < 20 {
      return .orange
    } else {
      return .red
    }
  }
  
  func handleToggle (toggle: Bool, player: Int, leader: Bool) {
    let toggleOf = leader ? "leader" : "base"
    let verbage = toggle ? "performed an epic action" : "revoked an epic action"
    let timestamp = getTimestamp()

    audit.append("\(timestamp): Player \(player) \(toggleOf) \(verbage)")
  }

  func handleInitiative (player: Int) {
    if player == 1 {
      if player1initiative {
        return
      }
      player1initiative = true
      player2initiative = false
    } else {
      if player2initiative {
        return
      }
      player1initiative = false
      player2initiative = true
    }
    
    let timestamp = getTimestamp()
    audit.append("\(timestamp): Player \(player) took initiative")
  }
  
  func handleReset(){
    player1damage = 0
    player1leader = false
    player1base = false
    player1initiative = true
    
    player2damage = 0
    player2leader = false
    player2base = false
    player2initiative = false
    
    audit = []
  }

  var body: some View {
    VStack {
      Spacer()
      Text("Star Wars: Unlimited")
        .font(.system(.largeTitle, design: .rounded))
      Spacer()
      GroupBox(label: Text("Player 1")) {
        Spacer()
        HStack {
          Spacer()
          VStack {
            Spacer()
            Button("-5") {
              handleDamage(player: 1, damage: -5)
            }
              .buttonStyle(.bordered)
            Spacer()
            Button("-3") {
              handleDamage(player: 1, damage: -3)
            }
              .buttonStyle(.bordered)
            Spacer()
            Button("-1") {
              handleDamage(player: 1, damage: -1)
            }
              .buttonStyle(.bordered)
            Spacer()
          }
          Spacer()
          Text("\(player1damage)")
            .foregroundColor(getDamageColor(damage: player1damage))
            .font(.system(.largeTitle, design: .rounded))
          Spacer()
          VStack {
            Spacer()
            Button("+5") {
              handleDamage(player: 1, damage: 5)
            }
              .buttonStyle(.bordered)
            Spacer()
            Button("+3") {
              handleDamage(player: 1, damage: 3)
            }
              .buttonStyle(.bordered)
            Spacer()
            Button("+1") {
              handleDamage(player: 1, damage: 1)
            }
              .buttonStyle(.bordered)
            Spacer()
          }
          Spacer()
        }
        Spacer()
        HStack {
          Spacer()
          VStack {
            Text("Leader")
            Toggle("", isOn: $player1leader)
              .onChange(of: player1leader) {oldState, newValue in
                handleToggle(toggle: newValue, player: 1, leader: true)
              }
                .labelsHidden()
          }
          Spacer()
          VStack {
            Text("Base")
            Toggle("Base", isOn: $player1base)
              .onChange(of: player1base) {oldState, newValue in
                handleToggle(toggle: newValue, player: 1, leader: false)
              }
                .labelsHidden()
          }
          Spacer()
          VStack {
            Text("Initiative")
            Button("\(player1initiative ? "Has" : "Take") Initiative") {
              handleInitiative(player: 1)
            }
              .buttonStyle(.bordered)
          }
          Spacer()
        }.toggleStyle(.switch)
        Spacer()
      }
      .scaleEffect(x: -1, y: -1)
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(.blue, lineWidth: player1initiative ? 8 : 0)
      )
      Spacer()
      GroupBox(label: Text("Player 2")) {
          Spacer()
          HStack {
            Spacer()
            VStack {
              Spacer()
              Button("-5") {
                handleDamage(player: 2, damage: -5)
              }
                .buttonStyle(.bordered)
              Spacer()
              Button("-3") {
                handleDamage(player: 2, damage: -3)
              }
                .buttonStyle(.bordered)
              Spacer()
              Button("-1") {
                handleDamage(player: 2, damage: -1)
              }
                .buttonStyle(.bordered)
              Spacer()
            }
            Spacer()
            Text("\(player2damage)")
              .foregroundColor(getDamageColor(damage: player2damage))
              .font(.system(.largeTitle, design: .rounded))
            Spacer()
            VStack {
              Spacer()
              Button("+5") {
                handleDamage(player: 2, damage: 5)
              }
                .buttonStyle(.bordered)
              Spacer()
              Button("+3") {
                handleDamage(player: 2, damage: 3)
              }
                .buttonStyle(.bordered)
              Spacer()
              Button("+1") {
                handleDamage(player: 2, damage: 1)
              }
                .buttonStyle(.bordered)
              Spacer()
            }
            Spacer()
          }
          Spacer()
          HStack {
            Spacer()
            VStack {
              Text("Leader")
              Toggle("", isOn: $player2leader)
                .onChange(of: player2leader) {oldState, newValue in
                  handleToggle(toggle: newValue, player: 2, leader: true)
                }.labelsHidden()
            }
            Spacer()
            VStack {
              Text("Base")
              Toggle("Base", isOn: $player2base)
                .onChange(of: player2base) {oldState, newValue in
                  handleToggle(toggle: newValue, player: 2, leader: false)
                }.labelsHidden()
            }
            Spacer()
            VStack {
              Text("Initiative")
              Button("\(player2initiative ? "Has" : "Take") Initiative"){
                handleInitiative(player: 2)
              }.buttonStyle(.bordered)
            }
            Spacer()
          }.toggleStyle(.switch)
          Spacer()
      }
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(.blue, lineWidth: player2initiative ? 8 : 0)
      )
      Spacer()
      HStack {
        Spacer()
        Button("Reset") {
          showConfirmation = true
          }
          .alert(isPresented: $showConfirmation) {
            Alert(
              title: Text("Are you sure you want to reset?"),
              // message: Text("This will reset all damage and epic actions."),
              primaryButton: .default(Text("Reset")) {
                handleReset()
              },
              secondaryButton: .cancel()
            )
          }
          .buttonStyle(.bordered)
        Spacer()
        Button("Log") {
          showingLog.toggle()
        }
        .popover(isPresented: $showingLog) {
          ScrollView {
            Spacer()
            VStack(spacing: 10) {
              ForEach(audit, id: \.self) { item in
                Text(item)
                //    .padding()
              }
            }
            Spacer()
          }
        }
        .multilineTextAlignment(.leading)
        .buttonStyle(.bordered)
        Spacer()
      }
      Spacer()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
