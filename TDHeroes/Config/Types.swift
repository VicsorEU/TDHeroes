//
//  Team.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import CoreGraphics

// Команды на поле
enum Team {
    case player
    case enemy
}

// Класс героя
enum HeroClass: String, CaseIterable {
    case archer = "Archer" // дальний, быстрые выстрелы
    case mage   = "Mage"   // сплэш по площади
    case warrior = "Warrior" // ближний, жирный
}

// Ресурсы
enum ResourceType: String, CaseIterable {
    case wood
    case stone
    case gold
    case xp
}

// Типы юнитов (для фабрики мобов)
enum UnitType {
    case grunt   // обычный
    case heavy   // медленный, толстый
    case fast    // быстрый, хрупкий
}

// Удобная структура денег/ресурсов
struct Cost {
    var gold: Int = 0
    var wood: Int = 0
    var stone: Int = 0
}
