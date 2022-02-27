//
//  APIService.swift
//  Translations-TV
//
//  Created by Brian Veitch on 2/26/22.
//

import Foundation
import Combine

class WebService {
    
    var cancellables = Set<AnyCancellable>()
    
    var translationTypes: [String] = [
        "pirate",
        "enderman",
        "shakespeare"
    ]
    
    func fetchTranslations(text: String) -> [AnyPublisher<Translation, Never>] {
        
        var returnPublisher = [AnyPublisher<Translation, Never>]()
        
        for type in translationTypes {
            
            let textToTranslate = text.replacingOccurrences(of: " ", with: "%20")
            
            let urlString = "https://api.funtranslations.com/translate/\(type).json?text=\(textToTranslate)"
            
            let url = URL(string: urlString)!
            
            let publisher = URLSession.shared.dataTaskPublisher(for: url)
                .map {$0.data}
                .decode(type: Translation.self, decoder: JSONDecoder())
                .replaceError(with: Translation(contents: Contents(translated: "ERROR", text: "ERROR", translation: "ERROR")))
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
            
            returnPublisher.append(publisher)
        }
        
        return returnPublisher

    }
    
   
}
