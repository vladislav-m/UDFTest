//
//  ContentView.swift
//  UDFTest
//
//  Created by Vladislav Myakotin on 23.11.2021.
//

import SwiftUI

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
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                EventsView(store: .init(
                    initialState: .init(),
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
