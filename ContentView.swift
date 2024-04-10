//
//  ContentView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 03.04.24.
//

import SwiftUI

struct ContentView: View {
    @ArrayAppStorage("friedowin.server") var servers: [FriedoWin.Server] = [.init(domain: "friedowin.lelux.net")]
    
    @State private var authenticated: FriedoWin? = nil
    @State private var reauthenticating = false
    @State private var authenticationError: Error? = nil
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Group {
                if let authenticated = authenticated {
                    authenticatedView(api: authenticated)
                } else {
                    loginView()
                }
            }
            .hidden(reauthenticating)
            
            if reauthenticating {
                ProgressView()
            }
        }
        .onAppear(perform: self.tryReauthenticate)
    }
    
    @ViewBuilder private func authenticatedView(api: FriedoWin) -> some View {
        FriedoWinView(api: api)
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
                
                if let error = authenticationError {
                    switch error {
                    case FriedoWin.Server.RequestError.friedoLinDown: loginFriedoLinDownErrorView()
                    default: loginOtherErrorView(error)
                    }
                }
                
                Spacer()
                
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

@propertyWrapper
struct ArrayAppStorage<Value>: DynamicProperty {
    var key: String
    var userDefaults: UserDefaults = .standard
    
    var wrappedValue: [Value] {
        get { cachedValue }
        set {
            userDefaults.setValue(userDefaults, forKey: key)
            cachedValue = newValue
        }
    }
    
    @State private var cachedValue: [Value]
    
    init(wrappedValue: [Value], _ key: String) {
        self.key = key
        self.cachedValue = wrappedValue
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main, using: self.receive(_:))
    }
    
    func receive(_ notification: Notification) {
        guard let object = notification.object else { return }
        guard let userDefaults = object as? UserDefaults else { return }
        guard userDefaults == self.userDefaults else { return }
        
        guard let array = userDefaults.array(forKey: key) else { return }
        guard let value = array as? [Value] else { return }
        self.cachedValue = value
    }
}
