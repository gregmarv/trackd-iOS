import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(white: 0.05).ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Profile")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Your fitness overview")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)

                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.4, green: 0.4, blue: 0.9).opacity(0.1))

                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                                }
                                .frame(width: 80, height: 80)

                                VStack(spacing: 4) {
                                    Text("User")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)

                                    Text("Member since March 2026")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(Color(white: 0.1))
                            .cornerRadius(12)

                            VStack(spacing: 16) {
                                ProfileStatCard(
                                    icon: "flame.fill",
                                    label: "Total Workouts",
                                    value: "24",
                                    color: Color(red: 0.9, green: 0.4, blue: 0.4)
                                )

                                ProfileStatCard(
                                    icon: "calendar.badge.checkmark",
                                    label: "Current Streak",
                                    value: "12 days",
                                    color: Color(red: 0.4, green: 0.7, blue: 0.4)
                                )

                                ProfileStatCard(
                                    icon: "clock.fill",
                                    label: "Total Duration",
                                    value: "18 hours",
                                    color: Color(red: 0.4, green: 0.4, blue: 0.9)
                                )

                                ProfileStatCard(
                                    icon: "target",
                                    label: "Active Programs",
                                    value: "1",
                                    color: Color(red: 0.9, green: 0.6, blue: 0.2)
                                )
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Weekly Summary")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                VStack(spacing: 10) {
                                    WeeklySummaryBar(day: "Mon", completed: true)
                                    WeeklySummaryBar(day: "Tue", completed: true)
                                    WeeklySummaryBar(day: "Wed", completed: false)
                                    WeeklySummaryBar(day: "Thu", completed: true)
                                    WeeklySummaryBar(day: "Fri", completed: false)
                                    WeeklySummaryBar(day: "Sat", completed: true)
                                    WeeklySummaryBar(day: "Sun", completed: false)
                                }
                            }
                            .padding(16)
                            .background(Color(white: 0.1))
                            .cornerRadius(12)
                        }
                        .padding(16)
                    }
                }
            }
        }
    }
}

struct ProfileStatCard: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
            }
            .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(12)
        .background(Color(white: 0.05))
        .cornerRadius(8)
    }
}

struct WeeklySummaryBar: View {
    let day: String
    let completed: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(day)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 30, alignment: .leading)

            RoundedRectangle(cornerRadius: 4)
                .fill(completed ? Color(red: 0.4, green: 0.4, blue: 0.9) : Color(white: 0.1))
                .frame(height: 8)

            if completed {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.4, green: 0.7, blue: 0.4))
            }
        }
    }
}

#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}
