//
//  ContentView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 03.04.24.
//

import SwiftUI

struct ContentView: View {
    enum TabSelection: String, Hashable {
        case news
        case personalInformation
        case schedule
        case cafeteria
    }
    
    @ArrayAppStorage("friedowin.server") var servers: [FriedoWin.Server] = [.init(domain: "friedowin.lelux.net")]
    
    @State private var authenticated: FriedoWin? = nil
    @State private var reauthenticating = false
    @State private var authenticationError: Error? = nil
    
    @State private var username = ""
    @State private var password = ""
    
    @AppStorage("selectedTab") private var selectedTab: TabSelection = .schedule
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NewsView(news: servers.news)
                .tag(TabSelection.news)
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            Group {
                if let authenticated = authenticated {
                    PersonalInformationView(personalInformation: authenticated.personalInformation)
                } else {
                    loginView()
                }
            }
            .tag(ContentView.TabSelection.personalInformation)
            .tabItem {
                Label("My Info", systemImage: "person.crop.circle")
            }
            
            Group {
                if let authenticated = authenticated {
                    ScheduleView(schedule: authenticated.schedule)
                } else {
                    loginView()
                }
            }
            .tag(ContentView.TabSelection.schedule)
            .tabItem {
                Label("Timetable", systemImage: "calendar")
            }
            
            MenuView(menu: servers.menu)
                .tag(TabSelection.cafeteria)
                .tabItem {
                    Label("Cafeteria", systemImage: "fork.knife")
                }
        }
        .onAppear(perform: self.tryReauthenticate)
    }
    
    @ViewBuilder private func loginView() -> some View {
        Form {
            VStack(spacing: 20) {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    (Text("Friedo") + Text("W").bold() + Text("in"))
                        .font(.largeTitle)
                    
                    Spacer()
                }
                
                VStack {
                    TextField("Username", text: $username)
                        .backgroundStyle(.tertiary)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.alphabet)
                        .textInputAutocapitalization(.never)
                        .scrollDismissesKeyboard(.immediately)
                        .textContentType(.username)
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $password)
                        .backgroundStyle(.tertiary)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .scrollDismissesKeyboard(.immediately)
                        .textContentType(.password)
                }
                .disabled(reauthenticating)
                
                if let error = authenticationError {
                    switch error {
                    case FriedoWin.Server.RequestError.friedoLinDown: loginFriedoLinDownErrorView()
                    default: loginOtherErrorView(error)
                    }
                }
                
                Spacer()
                
                if reauthenticating {
                    ProgressView()
                } else {
                    Button {
                        authenticate()
                    } label: {
                        Text("Log In")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
                    .tint(Color.accentColor)
                }
            }
        }
        .formStyle(.columns)
        .font(.title2)
        .padding()
        .padding()
    }
    
    @ViewBuilder private func loginFriedoLinDownErrorView() -> some View {
        VStack {
            Text("FriedoLin is currently not available.")
                .foregroundStyle(.red)
            
            Text("This may be due to regular maintenance work. Check out [friedoLin.uni-jena.de](https://friedolin.uni-jena.de/)")
                .font(.caption)
        }
    }
    
    @ViewBuilder private func loginNoServersErrorView() -> some View {
        VStack {
            Text("Authentication failed.")
                .foregroundStyle(.red)
            
            Text("No servers to authenticate.")
                .font(.caption)
        }
    }
    
    @ViewBuilder private func loginNoResultsErrorView() -> some View {
        Text("Authentication failed.")
            .foregroundStyle(.red)
    }
    
    @ViewBuilder private func loginOtherErrorView(_ error: Error) -> some View {
        VStack {
            Text("Authentication failed.")
                .foregroundStyle(.red)
            
            Text((error as CustomStringConvertible).description)
                .font(.caption)
        }
    }
    
    func authenticate(storeCredentials: Bool = true) {
        reauthenticating = true
        authenticationError = nil
        
        Task {
            defer { reauthenticating = false }
            do {
                self.authenticated = try await FriedoWin.authenticate(.init(username: username, password: password), with: servers)
                self.authenticated?.reauthenticate = self.tryReauthenticate // register authentication error listener
                
                if storeCredentials {
                    try? self.storeCredentials(username: username, password: password)
                }
            } catch {
                print(error)
                authenticationError = error
            }
        }
    }
    
    func tryReauthenticate() {
        if let credentials = try? loadCredentials() {
            username = credentials.username
            password = credentials.password
            authenticate(storeCredentials: false)
        }
    }
    
    func friedoLinDown() {
        self.authenticated = nil
        self.authenticationError = FriedoWin.Server.RequestError.friedoLinDown
    }
    
    private func loadCredentials() throws -> Keychain.Credentials? {
        try Keychain.default.fetchItem(for: "friedowin.lelux.net")
    }
    
    private func storeCredentials(username: String, password: String) throws {
        try Keychain.default.addItem(.init(username: username, password: password), for: "friedowin.lelux.net")
    }
}

#Preview {
    ContentView()
}

extension UInt16: RawRepresentable {
    public typealias RawValue = Int
    
    public var rawValue: Int { .init(self) }
    
    public init?(rawValue: Int) {
        guard rawValue >= Int(Self.min) else { return nil }
        guard rawValue <= Int(Self.max) else { return nil }
        self.init(rawValue)
    }
}
