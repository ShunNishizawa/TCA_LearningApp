//
//  AppState.swift
//  TCA_SampleApp
//
//  Created by 西澤駿 on 2022/10/04.
//

import ComposableArchitecture
import Dispatch

struct AppState: Equatable {
  var count = 0 // 画面に表示するカウンタの値
  var numberFactAlert: String? // 画面の「Numberfact」ボタンを押下したときにアラートで表示する文字列が格納される
}

enum AppAction: Equatable {
  case factAlertDismissed
  case decrementButtonTapped
  case incrementButtonTapped
  case numberFactButtonTapped
  case numberFactResponse(Result<String, ApiError>)
}

struct ApiError: Error, Equatable {}

// Environmentは1つの機能において必要となる依存を保持する。
struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var numberFact: (Int) -> Effect<String, ApiError>
}

// 各アクションに対応する「Stateへの処理」と「実行するべきEffect」について記載
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  switch action {
  case .factAlertDismissed:
    state.numberFactAlert = nil
    return .none

  case .decrementButtonTapped:
    state.count -= 1
    return .none

  case .incrementButtonTapped:
    state.count += 1
    return .none

  case .numberFactButtonTapped:
    return environment.numberFact(state.count)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(AppAction.numberFactResponse)

  case let .numberFactResponse(.success(fact)):
    state.numberFactAlert = fact
    return .none

  case .numberFactResponse(.failure):
    state.numberFactAlert = "Could not load a number fact :("
    return .none
  }
}
