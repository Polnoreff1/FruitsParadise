//
//  Network.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//

import Foundation

protocol INetwork {
    func getWish(closure: @escaping (Wish) -> ())
}

class Network: INetwork {
    func getWish(closure: @escaping (Wish) -> ()) {
        guard let url = URL(string: "http://yerkee.com/api/fortune") else { return }
        
        let request = NSMutableURLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            if let response = response {
                print(response)
            }
            
            if let data = data {
                print(data)
            }
            
            let decoder = JSONDecoder()
            do {
                if let data {
                    let wish = try decoder.decode(Wish.self, from: data)
                    DispatchQueue.main.async {
                        closure(wish)
                    }
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
