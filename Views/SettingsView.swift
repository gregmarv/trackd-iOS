import SwiftUI

struct SettingsView: View {
    @State private var showExportAlert = false
    @State private var showImportAlert = false
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(white: 0.05).ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Manage your app preferences")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)

                    ScrollView {
                        VStack(spacing: 24) {
                            SettingsSectionView(title: "Data") {
                                SettingsButtonRow(
                                    icon: "arrow.up.doc",
                                    label: "Export Data",
                                    action: { showExportAlert = true }
                                )

                                SettingsButtonRow(
                                    icon: "arrow.down.doc",
                                    label: "Import Data",
                                    action: { showImportAlert = true }
                                )

                                SettingsButtonRow(
                                    icon: "trash.fill",
                                    label: "Reset All Data",
                                    destructive: true,
                                    action: { showResetAlert = true }
                                )
                            }

                            SettingsSectionView(title: "About") {
                                SettingsInfoRow(label: "App Version", value: "1.0.0")
                                SettingsInfoRow(label: "Build Number", value: "1")
                                SettingsInfoRow(label: "Last Updated", value: "March 2026")
                            }

                            SettingsSectionView(title: "Legal") {
                                NavigationLink {
                                    VStack {
                                        Text("Privacy Policy")
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .navigationTitle("Privacy Policy")
                                } label: {
                                    HStack {
                                        Text("Privacy Policy")
                                            .foregroundColor(.white)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(12)
                                    .background(Color(white: 0.1))
                                    .cornerRadius(8)
                                }

                                NavigationLink {
                                    VStack {
                                        Text("Terms of Service")
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .navigationTitle("Terms of Service")
                                } label: {
                                    HStack {
                                        Text("Terms of Service")
                                            .foregroundColor(.white)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(12)
                                    .background(Color(white: 0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
        }
        .alert("Export Data", isPresented: $showExportAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Export") {
                // Export data
            }
        } message: {
            Text("Your workout data will be saved to Files app. You can then share it via email or cloud storage.")
        }
        .alert("Import Data", isPresented: $showImportAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Import") {
                // Import data
            }
        } message: {
            Text("Select a previously exported trackd data file to restore your workouts and programs.")
        }
        .alert("Reset All Data?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                // Reset data
            }
        } message: {
            Text("This will permanently delete all your workouts, programs, and settings. This cannot be undone.")
        }
    }
}

struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            VStack(spacing: 8) {
                content
            }
        }
        .padding(16)
        .background(Color(white: 0.1))
        .cornerRadius(12)
    }
}

struct SettingsButtonRow: View {
    let icon: String
    let label: String
    var destructive = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(destructive ? Color(red: 0.7, green: 0.3, blue: 0.3) : Color(red: 0.4, green: 0.4, blue: 0.9))
                    .frame(width: 24)

                Text(label)
                    .foregroundColor(destructive ? Color(red: 0.7, green: 0.3, blue: 0.3) : .white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(12)
            .background(Color(white: 0.05))
            .cornerRadius(8)
        }
    }
}

struct SettingsInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)

            Spacer()

            Text(value)
                .foregroundColor(.white)
                .fontWeight(.medium)
        }
        .padding(12)
        .background(Color(white: 0.05))
        .cornerRadius(8)
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
