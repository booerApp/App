//
//  AppReducer .swift
//  Booer (iOS)
//
//  Created by Veit Progl on 21.04.22.
//

import ComposableArchitecture
import SwiftUI

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    calendarReducer.pullback(state: \.calendar,
                             action: /AppAction.calendar,
                             environment: { _ in CalendarEnvironment() }),
  Reducer { state, action, environment in
      switch action {
      default:
          return .none
      }
  })
