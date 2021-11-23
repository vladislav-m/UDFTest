//
//  ContentView.swift
//  UDFTest
//
//  Created by Vladislav Myakotin on 23.11.2021.
//

import SwiftUI

struct SignInView: View {
    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        Form {
            TextField("Username", text: $username)
            TextField("Password", text: $password)
            Button("Sign In") {
                print("Signed in")
            }
        }
    }
}

struct MainView: View {
    @State var isAuthorized: Bool = false

    var body: some View {
        if isAuthorized {
            MainTabView()
        } else {
            SignInView()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
