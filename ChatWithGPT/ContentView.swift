//
//  ContentView.swift
//  ChatWithGPT
//
//  Created by Shubhayu Shrestha on 4/9/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var chatMessages: [ChatMessage] = [] ;
    @State var messageToSend:  String = ""
    @State var cancellables = Set<AnyCancellable>()
    // creating an instance of the service
    let openAIService = OpenAIService()
    
    var body: some View {
        // change to lazy so that the list can be dynamically loaded
        VStack{
            GPTTile()
            ScrollView{
                LazyVStack {
                    ForEach(chatMessages, id: \.id) { message in
                        messageBubble(message: message)
                        .padding(2)
                    }
                }
            }
            .padding()
            HStack{
                Image(systemName: "camera.fill")
                    .foregroundColor(.gray)
                    .padding()
                Image(systemName: "appclip")
                    .foregroundColor(.gray)
                HStack{
                    TextField("iMessage", text: $messageToSend){
                    }
                        .padding()
                        .cornerRadius(50)
                    Button {
                        if !messageToSend.isEmpty {
                            sendMessage()
                        }
                            
                    } label: {
                        if messageToSend.isEmpty {
                            Image(systemName: "mic")
                                .foregroundColor(.gray)
                                .padding(10)
                        }
                        if !messageToSend.isEmpty {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.blue)
                                .cornerRadius(50)
                        }
     
                    }
                    .padding(.horizontal)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(.gray, lineWidth: 1)
                )
                .padding()
                .padding(.horizontal, 10)
            }
        }
    }
    
    func messageBubble(message: ChatMessage) -> some View {
        HStack{
            if message.sender == .me { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : .black)
                .padding()
                .background(message.sender == .me ? .blue : .gray.opacity(0.1))
                .cornerRadius(36)
            if message.sender == .ChatGPT { Spacer() }
        }

    }
    
    func sendMessage() {
        // store message into the message array
        let myMessage = ChatMessage(id: UUID().uuidString, content: messageToSend, timestamp: Date(), sender: .me)
        chatMessages.append(myMessage)
        // clearing out the text
        openAIService.sendMessage(message: messageToSend).sink {completion in
        } receiveValue: { response in
            guard let apiResponse = response.choices.first?.text else {return}
            let gptMessage = ChatMessage(id: response.id, content: apiResponse, timestamp: Date(), sender: .ChatGPT)
            chatMessages.append(gptMessage)
        }
        .store(in: &cancellables)
        
        messageToSend = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ChatMessage {
    let id: String;
    let content: String;
    let timestamp: Date;
    let sender: MessageSender;
}

enum MessageSender{
    case me;
    case ChatGPT ;
}
