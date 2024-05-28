//
//  FuturePublisher.swift
//  SwiftUIPublishers
//
//  Created by Saurabh Bisht on 28/05/24.
//

import SwiftUI
import Combine

class FuturePublisherViewModel: ObservableObject {
    @Published var message: String = "Loading..."
    
    private var cancellable: AnyCancellable?

    init() {
        fetchData()
    }
    
    func fetchData() {
        cancellable = fetchMessage()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.message = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { value in
                self.message = value
            })
    }
    
    private func fetchMessage() -> Future<String, Error> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                let success = Bool.random()
                if success {
                    promise(.success("If you download this give this a star in github!!!"))
                } else {
                    promise(.failure(NSError(domain: "FetchError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed"])))
                }
            }
        }
    }
}

struct FuturePublisherView: View {
    @ObservedObject var viewModel = FuturePublisherViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.message)
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .padding()
    }
}

struct FuturePublisherView_Previews: PreviewProvider {
    static var previews: some View {
        FuturePublisherView()
    }
}
