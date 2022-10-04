//
//  ContentView.swift
//  TCA_SampleApp
//
//  Created by 西澤駿 on 2022/10/04.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {

  let store: Store<AppState, AppAction>

  var body: some View {
      // WithViewStoreでViewにStoreを組み込む。WithViewStoreはSwiftUIのViewを返すので、var body: some View{}の無垢で使うことができる
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Button("−") { viewStore.send(.decrementButtonTapped) }
          Text("\(viewStore.count)")
          Button("+") { viewStore.send(.incrementButtonTapped) }
        }

        Button("Number fact") { viewStore.send(.numberFactButtonTapped) }
      }
      .alert(
        item: viewStore.binding(
          get: { $0.numberFactAlert.map(FactAlert.init(title:)) },
          send: .factAlertDismissed
        ),
        content: { Alert(title: Text($0.title)) }
      )
    }
  }
}

struct FactAlert: Identifiable {
  var title: String
  var id: String { self.title }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      store: Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
          mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
          numberFact: { number in
            Effect(value: "\(number) is a good number Brent")
          }
        )
      )
    )
  }
}
