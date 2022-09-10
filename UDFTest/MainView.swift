//
//  ContentView.swift
//  UDFTest
//
//  Created by Vladislav Myakotin on 23.11.2021.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct MainView: View {
    @State var isAuthorized: Bool = true

    var body: some View {
        if isAuthorized {
            MainTabView()
        } else {
            SignInView(store: .init(
                initialState: .init(),
                reducer: .signIn,
                environment: .live
            ))
struct MainViewState: Equatable {
    var isAuthorized: Bool = false
}

enum MainViewAction {
    case viewDidLoad
    case set(isAuthorized: Bool)
}

struct MainEnvironment {
    private var isAuthorizedPublisher: AnyPublisher<Bool, Never>
    internal init(isAuthorizedPublisher: AnyPublisher<Bool, Never>) {
        self.isAuthorizedPublisher = isAuthorizedPublisher
    }
    func isAuthorized() -> Effect<MainViewAction, Never> {
        self.isAuthorizedPublisher
            .map(MainViewAction.set(isAuthorized:))
            .eraseToEffect()
    }
}

extension Reducer where State == MainViewState, Action == MainViewAction, Environment == MainEnvironment {
    static let main = Reducer { state, action, environment in
        switch action {
        case .viewDidLoad:
            return .none
        case let .set(isAuthorized):
            state.isAuthorized = isAuthorized
            return .none
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                EventsView(store: .init(
                    initialState: .init(events:
                                            [
                                                Event(
                                                    name: "Ивент 1",
                                                    description: "dsfsdf",
                                                    speeches: [],
                                                    date: Date()
                                                ),
                                                Event(
                                                    name: "Ивент 2",
                                                    description: "dsfsdf",
                                                    speeches: [],
                                                    date: Date().addingTimeInterval(-60*60*24*3)
                                                ),
                                                Event(
                                                    name: "Ивент 3",
                                                    description: "dsfsdf",
                                                    speeches: [],
                                                    date: Date().addingTimeInterval(-60*60*24*2)
                                                ),
                                                Event(
                                                    name: "Ивент 4",
                                                    description: "dsfsdf",
                                                    speeches: [],
                                                    date: Date().addingTimeInterval(-60*60*24)
                                                ),
                                                Event(
                                                    name: "Ивент 5",
                                                    description: "dsfsdf",
                                                    speeches: [],
                                                    date: Date().addingTimeInterval(60*60*24*2)
                                                )
                                            ]),
                    reducer: .events,
                    environment: ()
                ))
            }
            .tabItem {
                Text("Events")
                Image(systemName: "trash")
            }
            ProfileView().tabItem {
                Text("Profile")
                Image(systemName: "person")
            }
        }
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile")
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
