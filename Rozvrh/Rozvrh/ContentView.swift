
//  ContentView.swift
//  Rozvrh
//  Created by Dominik Horký on 24.10.2024.

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var isLoggedIn: Bool = false
    
    func login(username: String, password: String) {
        guard let url = URL(string: "https://is.czu.cz/system/login.pl") else {
            message = "Neplatná URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = "login_hidden=1&destination=/auth/&auth_id_hidden=0&auth_2fa_type=no&credential_0=\(username)&credential_1=\(password)&credential_k=&credential_2=86400"
        request.httpBody = bodyString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.message = "Chyba: \(error.localizedDescription)"
                    self.isLoggedIn = false
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200,
                   let redirectUrl = httpResponse.url?.absoluteString,
                   redirectUrl == "https://is.czu.cz/auth/" {
                    DispatchQueue.main.async {
                        self.message = "Přihlášení se povedlo!"
                        self.isLoggedIn = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.message = "Přihlášení se nezdařilo. Zkontrolujte své údaje."
                        self.isLoggedIn = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.message = "Nastala chyba při přihlašování."
                }
            }
        }

        task.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack {
                    Image("Logo_czu_cz")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .frame(maxWidth: 295)
                    
                    Text("Přihlášení pomocí UIS")
                        .font(.title)
                        .bold()
                        .padding(.top, 50 )
                        .padding(.bottom, 40 )
                                                
                    TextField("Uživatelské jméno", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: 360)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    SecureField("Heslo", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: 360)
                    
                    Button(action: {
                        viewModel.login(username: username, password: password)
                    }) {
                        Text("Přihlásit se")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 40)
                            .bold()
                    }
                    .padding([.leading, .trailing], 20)
                    
                    Text(viewModel.message)
                        .padding()
                        .foregroundColor(viewModel.message.contains("nezdařilo") ? .red : .green)

                    NavigationLink(destination: DashboardView(), isActive: $viewModel.isLoggedIn) {
                        EmptyView()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
        }
    }
}


#Preview {
    ContentView()
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
