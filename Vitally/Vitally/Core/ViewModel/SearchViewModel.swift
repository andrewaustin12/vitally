import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var products: [SearchResultProduct] = []
    @Published var isLoading: Bool = false
    @Published var currentPage: Int = 1
    @Published var canLoadMore: Bool = true
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchTerm
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.resetSearch()
            }
            .store(in: &cancellables)
    }
    
    func resetSearch() {
        products = []
        currentPage = 1
        canLoadMore = true
        Task {
            await performSearch()
        }
    }
    
    @MainActor
    func performSearch() async {
        guard !searchTerm.isEmpty, !isLoading, canLoadMore else { return }
        
        isLoading = true
        
        let searchURL = "https://world.openfoodfacts.org/cgi/search.pl?search_terms=\(searchTerm)&search_simple=1&action=process&json=1&page=\(currentPage)"
        
        guard let url = URL(string: searchURL) else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(SearchAPIResponse.self, from: data)
            products.append(contentsOf: decodedResponse.products)
            currentPage += 1
            canLoadMore = !decodedResponse.products.isEmpty
        } catch {
            print("Failed to decode response: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}
