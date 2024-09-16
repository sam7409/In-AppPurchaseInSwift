//
//  NetworkManager.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import Foundation

class NetworkManager {
    private let apiEndpoint = "https://example.com/api"
    private let authToken = "YOUR_AUTH_TOKEN"
    private let timeoutInterval: TimeInterval = 30.0
    
    func validateReceipt(receiptData: Data, completion: @escaping (Result<ReceiptValidationResult, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "\(apiEndpoint)/validateReceipt")!)
        request.httpMethod = "POST"
        request.httpBody = receiptData
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = timeoutInterval
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let validationResult = try JSONDecoder().decode(ReceiptValidationResult.self, from: data)
                completion(.success(validationResult))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func checkGracePeriod(userId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "\(apiEndpoint)/checkGracePeriod?userId=\(userId)")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = timeoutInterval
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let isInGracePeriod = try JSONDecoder().decode(Bool.self, from: data)
                completion(.success(isInGracePeriod))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct ReceiptValidationResult: Decodable {
    let isValid: Bool
}
