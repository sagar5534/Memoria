//
//  Settings.swift
//  Memoria
//
//  Created by Sagar R Patel on 2022-01-03.
//

import SwiftUI

struct Settings: View {
    @AppStorage("userName") private var userName = "User"
    @AppStorage("userEmail") private var userEmail = "User@email.com"
    @AppStorage("signedIn") private var signedIn: Bool = false

    var body: some View {
        List {
            Section {
                HStack(alignment: .center) {
                    UserImage()
                        .frame(width: 60, height: 60, alignment: .center)
                        .padding(.trailing, 7)

                    VStack(alignment: .leading) {
                        Text(userName)
                            .foregroundColor(.blue)
                            .font(.system(size: 18))
                            .lineLimit(nil)
                        Text(userEmail)
                            .foregroundColor(.secondary)
                            .font(.system(size: 15))
                            .lineLimit(nil)
                    }
                }
                .padding(.vertical, 10)

                NavigationLink(
                    destination: UserInfo(),
                    label: {
                        Text("Name & Email")
                    }
                )
                NavigationLink(
                    destination: Text("Coming Soon"),
                    label: {
                        Text("Password & Security")
                    }
                )
                Button(action: {
                    print("Signing out user")
                    signedIn = false
                }, label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                })
            }

            Section(header: Text("Backups")) {
                NavigationLink(
                    destination: BackupSync(),
                    label: {
                        Text("Backup & Sync")
                    }
                )
            }

            Section(header: Text("About")) {
                NavigationLink(
                    destination: SettingsWebView(url: URL(string: "https://sagarp.ca/Memoria/privacy.html")!),
                    label: {
                        Text("Data Privacy")
                    }
                )
                NavigationLink(
                    destination: SettingsWebView(url: URL(string: "https://sagarp.ca/Memoria/terms.html")!),
                    label: {
                        Text("Terms of Use")
                    }
                )
                NavigationLink(
                    destination: HelpSupport(),
                    label: {
                        Text("Help & Support")
                    }
                )
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text("Settings"))
    }
}

private struct UserInfo: View {
    @AppStorage("userName") private var userName = "User"
    @AppStorage("userEmail") private var userEmail = "User@email.com"
    @State private var textfield: String = ""

    var body: some View {
        List {
            Section {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        UserImage()
                            .frame(width: 100, height: 100, alignment: .center)
                        Spacer()
                    }
                    .padding(.vertical, 10)

                    Divider()
                    Button(action: {}, label: {
                        Text("Change Profile Image")
                    })
                    .disabled(true)
                    .padding(.vertical, 10)
                }
            }

            Section {
                Picker(selection: $textfield, label:
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(userName)
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                            .lineLimit(1)
                    }, content: {
                        TextField(userName, text: $textfield) { _ in } onCommit: {
                            checkEnteredName()
                        }
                        .navigationBarItems(trailing:
                            Button(action: {
                                checkEnteredName()
                            }, label: {
                                Text("Save")
                            }).foregroundColor(.blue))

                    })
                .padding(.vertical, 10)
            }

            Section {
                HStack {
                    Text("Email")
                    Spacer()
                    Text(userEmail)
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                        .lineLimit(1)
                }
                .padding(.vertical, 10)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Name & Email")
        .navigationBarTitleDisplayMode(.inline)
    }

    func checkEnteredName() {
        if !textfield.isEmpty {
            userName = textfield
            textfield = ""
        }
    }
}

private struct BackupSync: View {
    @AppStorage("backupEnabled") private var backupEnabled = false
    @AppStorage("cellularBackup") private var cellularBackup = false

    var body: some View {
        List {
            Section {
                VStack {
                    HStack {
                        Text("Upload, view, organize & share your photos from any device")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }

                    Toggle(isOn: $backupEnabled) {
                        Text("Backup & Sync")
                    }
                }
                .padding(.vertical, 10)
            }

            Section {
                VStack {
                    HStack {
                        Text("When not connected to WI-FI, use your cellular network to automatically back up to your Memoria Instance. This may cause you to exceed your cellular data plan.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }

                    Toggle(isOn: $cellularBackup) {
                        Text("Back Up Over Cellular")
                    }
                    .disabled(!backupEnabled)
                }
                .padding(.vertical, 10)
            }

            Section {
                Button(action: {
                    print("Backup Forced")
                }, label: {
                    Text("Backup Now")
                })
                .disabled(!backupEnabled)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Backup & Sync")
        .navigationBarTitleDisplayMode(.inline)
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
                        icon: { Image(systemName: "doc.plaintext") }
                    )
                })
                Link(destination: URL(string: "mailto:s.72427patel@gmail.com")!, label: {
                    Label(
                        title: { Text("Contact Developer") },
                        icon: { Image(systemName: "envelope.badge") }
                    )
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
        NavigationView {
            Settings()
        }

        NavigationView {
            UserInfo()
        }

        NavigationView {
            BackupSync()
        }

        NavigationView {
            HelpSupport()
        }
    }
}
