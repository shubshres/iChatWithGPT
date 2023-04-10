//
//  OpenAIService.swift
//  ChatWithGPT
//
//  Created by Shubhayu Shrestha on 4/9/23.
//

import Foundation
import Alamofire
import Combine

class OpenAIService {
    let baseURL = "https://api.openai.com/v1/completions"
    
    func sendMessage(message: String) -> AnyPublisher<OpenAIResponse, Error>  {
        let body = OpenAIRequestBody(model: "\(Constants.model)", prompt: message , temperature: 0.8)
        // creating headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAPIKey)"
        ]
        return Future { [weak self] promise in
            guard let self = self else { return }
            // start building request
            AF.request(baseURL, method: .post, parameters: body, encoder: .json , headers: headers).responseDecodable(of: OpenAIResponse.self) { response in
                switch response.result{
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

//  function that creates body for the API Request
struct OpenAIRequestBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
}
 
struct OpenAIResponse: Decodable{
    let id: String
    let choices: [OpenAICompletionChoices]
}

struct OpenAICompletionChoices: Decodable {
    let text: String
     
}
