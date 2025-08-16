//
//  GameKitRealtime.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import Foundation
import GameKit

// Каркас для онлайна через Game Center.
// В v1 он не активирован, но код готов для добавления:
// - аутентификация игрока
// - создание матча
// - отправка команд (JSON)

final class GameKitRealtime: NSObject {
    static let shared = GameKitRealtime()

    private var match: GKMatch?

    // Вызвать при старте, чтобы показать логин Game Center
    func authenticate(from vc: UIViewController) {
        GKLocalPlayer.local.authenticateHandler = { gcVC, error in
            if let gcVC { vc.present(gcVC, animated: true) }
            if let error { print("GC auth error:", error) }
        }
    }

    // Быстрый матч 1х1
    func findMatch(completion: @escaping (GKMatch?) -> Void) {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        GKMatchmaker.shared().findMatch(for: request) { [weak self] match, error in
            if let error { print("findMatch error:", error) }
            self?.match = match
            completion(match)
        }
    }

    // Отправить команду как JSON
    func sendCommand(_ dict: [String: Any]) {
        guard let m = match else { return }
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            try m.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("send error:", error)
        }
    }
}
