//
//  JustPublisher.swift
//  SwiftUIPublishers
//
//  Created by Saurabh Bisht on 28/05/24.
//

import SwiftUI
import Combine

class JustPublisherViewModel: ObservableObject {
    @Published var message: String = ""
    var justmessage: String = "If you download this give this a star in github"
    
    private var cancellable: AnyCancellable?

    init() {
        setupJustPublisher()
    }
    
    private func setupJustPublisher() {
        let justPublisher = Just(justmessage)
        
        cancellable = justPublisher
            .sink { [weak self] value in
                self?.message = value
            }
    }
}

struct JustPublisherView: View {
    @ObservedObject var viewModel = JustPublisherViewModel()
    
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

struct JustPublisherView_Previews: PreviewProvider {
    static var previews: some View {
        JustPublisherView()
    }
}

