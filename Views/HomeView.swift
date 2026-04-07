import SwiftUI

struct HomeView: View {
    @State private var navigateToSetup = false
    @State private var selectedCategory: String?

    let categories = [
        ("💪", "Upper Body"),
        ("🦵", "Lower Body"),
        ("⚙️", "Core"),
        ("🏃", "Cardio"),
        ("🤸", "Full Body"),
        ("🧘", "Flexibility"),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("trackd")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))

                    Text("What are we working on today?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                        ForEach(categories, id: \.1) { emoji, name in
                            NavigationLink(value: name) {
                                VStack(spacing: 12) {
                                    Text(emoji)
                                        .font(.system(size: 40))

                                    Text(name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                                .background(Color(white: 0.15))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationDestination(for: String.self) { category in
                SetupView(category: category)
            }
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
