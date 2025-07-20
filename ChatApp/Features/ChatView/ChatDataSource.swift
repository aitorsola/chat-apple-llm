//
//  ChatDataSource.swift
//  Test
//
//  Created by Aitor Sola on 19/7/25.
//

import Foundation
import SwiftUI
import Combine
import FoundationModels

@MainActor
class ChatDataSource: ObservableObject {
    let id: UUID = UUID()
    @Published var temperature: CGFloat = 2.0
    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var session = LanguageModelSession(instructions: {
        "If you don't know what to answer or can't answer because policy just say, just say: I don't know."
    })
    
    private let model: SystemLanguageModel
    
    weak var mainDataSource: ChatsDataSource?

    public init(loadSample: Bool, main: ChatsDataSource) {
        model = .default
        mainDataSource = main
        if loadSample {
            loadSampleConversation()
        }
    }

    func send(_ text: String) async {
        messages.append(.init(text: text, isMachine: false))
        
        do {
            let response = try await session.respond(to: text, options: GenerationOptions(
                sampling: .greedy,
                temperature: temperature)
            ).content
            
            messages.append(ChatMessage(text: response, isMachine: true))
        } catch {
            messages.append(ChatMessage(text: "Cannot answer 💀", isMachine: true))
        }
    }
    
    func clear() {
        mainDataSource?.remove(id)
    }
    
    func chatIsAvailable() -> Bool {
        model.isAvailable
    }
}

private extension ChatDataSource {
    
    func loadSampleConversation() {
        messages = [
            .init(text: "Hola, ¿cómo estás hoy?", isMachine: false),
            .init(text: "Hola, estoy bien, gracias. ¿Y tú?", isMachine: true),
            .init(text: "Un poco cansado, pero contento de hablar contigo.", isMachine: false),
            .init(text: "Me alegra escucharlo. ¿Qué has hecho hoy?", isMachine: true),
            .init(text: "Trabajé todo el día, pero luego di un paseo para despejarme.", isMachine: false),
            .init(text: "Eso suena genial, un buen paseo siempre ayuda.", isMachine: true),
            .init(text: "Sí, necesitaba aire fresco. ¿Y tú, qué haces cuando quieres relajarte?", isMachine: false),
            .init(text: "Me gusta leer o escuchar música tranquila. ¿Tienes algún pasatiempo?", isMachine: true),
            .init(text: "Me gusta pintar, aunque no soy muy bueno todavía.", isMachine: false),
            .init(text: "Lo importante es disfrutarlo, no ser perfecto. ¿Qué te gusta pintar?", isMachine: true),
            .init(text: "Paisajes y a veces animales. Me ayuda a desconectar.", isMachine: false),
            .init(text: "Qué bonito, la naturaleza tiene mucho para inspirar.", isMachine: true),
            .init(text: "Sí, me hace sentir en paz.", isMachine: false),
            .init(text: "Me alegra que encuentres momentos así. ¿Quieres que te cuente algo divertido?", isMachine: true),
            .init(text: "Claro, me vendría bien reír un poco.", isMachine: false),
            .init(text: "¿Sabes por qué las bicicletas no pueden pararse solas? Porque están dos-tired (demasiado cansadas).", isMachine: true),
            .init(text: "Jajaja, buen chiste. Gracias por alegrarme el día.", isMachine: false),
            .init(text: "De nada, aquí estaré siempre que quieras charlar.", isMachine: true)
        ]
    }
}
