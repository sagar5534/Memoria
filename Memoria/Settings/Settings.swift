//
//  Settings.swift
//  Memoria
//
//  Created by Sagar R Patel on 2022-01-03.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(alignment: .center) {
                        UserImage()
                            .frame(width: 60, height: 60, alignment: .center)
                            .padding(.trailing, 7)

                        VStack(alignment: .leading) {
                            Text("Sagar Patel")
                                .foregroundColor(.blue)
                                .font(.system(size: 18))
                                .lineLimit(nil)
                            Text("Account, Email & Purchases")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                                .lineLimit(nil)
                        }
                    }
                    .padding(.vertical, 10)

                    Button(action: {}, label: {
                        Text("Logout")
                            .foregroundColor(.red)
                    })
                }

//                Section(header: Text("Notifications settings")) {
//                    Toggle(isOn: $settings.isNotificationEnabled) {
//                        Text("Notification:")
//                    }
//                }
//
//                Section(header: Text("Sleep tracking settings")) {
//                    Toggle(isOn: $settings.isSleepTrackingEnabled) {
//                        Text("Sleep tracking:")
//                    }
//
//                    Picker(
//                        selection: $settings.sleepTrackingMode,
//                        label: Text("Sleep tracking mode")
//                    ) {
//                        ForEach(SettingsStore.SleepTrackingMode.allCases, id: \.self) {
//                            Text($0.rawValue).tag($0)
//                        }
//                    }
//
//                    Stepper(value: $settings.sleepGoal, in: 6 ... 12) {
//                        Text("Sleep goal is \(settings.sleepGoal) hours")
//                    }
//                }

                Section(header: Text("About")) {
//
                    NavigationLink(
                        destination: SettingsWebView(url: URL(string: "https://kuppajo.appspot.com/privacy")!),
                        label: {
                            Text("Data Policy")
                        })

                    NavigationLink(
                        destination: SettingsWebView(url: URL(string: "https://kuppajo.appspot.com/terms")!),
                        label: {
                            Text("Terms of Use")
                        })

                    NavigationLink(
                        destination: HelpSupport(),
                        label: {
                            Text("Help & Support")
                        })
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Settings"))
        }
    }
}

private struct HelpSupport: View {
    var body: some View {
        List {
            Section {
                Text("If you're having trouble using Memoria, we have lots of resources available to assist you. Our Github site includes documentation, user guides, answers to Frequently asked questions, and more. If you cannot find an answer there, our user community on Github is a great place to discuss issues and find help.")
                    .padding(.vertical, 10)
            }

            Section(header: Text("Links")) {
                Link(destination: URL(string: "https://github.com/sagar5534/Memoria-IOS")!, label: {
                    Label(
                        title: { Text("Github") },
                        icon: { Image(systemName: "doc.plaintext") })
                })
                Link(destination: URL(string: "mailto:s.72427patel@gmail.com")!, label: {
                    Label(
                        title: { Text("Contact Developer") },
                        icon: { Image(systemName: "envelope.badge") })
                })
            }
            .padding(.vertical, 10)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
