//
//  TCA_SampleAppApp.swift
//  TCA_SampleApp
//
//  Created by 西澤駿 on 2022/10/04.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_SampleAppApp: App {
    var body: some Scene {
      WindowGroup {
        ContentView(
          store: Store(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(
              mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
              numberFact: { number in
                  // hu
                Effect(value: "\(number) is a good number Brent")
              }
            )
          )
        )
      }
    }
}
