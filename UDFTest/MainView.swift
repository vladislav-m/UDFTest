//
//  ContentView.swift
//  UDFTest
//
//  Created by Vladislav Myakotin on 23.11.2021.
//

import SwiftUI
import SignInUI

struct MainView: View {
    @State var isAuthorized: Bool = false

    var body: some View {
        if isAuthorized {
            MainTabView()
        } else {
            SignInView(viewModel: .init())
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            EventsView().tabItem {
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

struct EventsView: View {
    var body: some View {
        Text("Events")
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
