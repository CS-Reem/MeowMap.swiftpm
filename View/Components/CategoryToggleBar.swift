import SwiftUI

struct CategoryToggleBar: View {

    @ObservedObject var viewModel: PlaceSearchViewModel

    var body: some View {
        HStack(spacing: 10) {
            ForEach(PlaceCategory.allCases) { category in
                let isActive = viewModel.activeCategories.contains(category)
                Button { viewModel.toggleCategory(category) } label: {
                    HStack(spacing: 5) {
                        Image(systemName: category.icon).font(.caption)
                        Text(category.rawValue).font(.caption).fontWeight(.semibold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(isActive ? category.swiftUIColor : Color(.systemGray5))
                    .foregroundStyle(isActive ? .white : .secondary)
                    .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}
