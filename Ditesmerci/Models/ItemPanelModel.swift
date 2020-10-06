//
//  ItemPanelModel.swift
//  Ditesmerci
//
//  Created by 7k04 on 05/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit

struct ItemPanelModel {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    static func allItemPanel() -> [ItemPanelModel] {
        return [
            ItemPanelModel(title: ""),
            ItemPanelModel(title: "IDENTITÉ"),
            ItemPanelModel(title: "FICHE PROFESSIONNELLE"),
            ItemPanelModel(title: "INFORMATIONS FINANCIÈRES"),
            ItemPanelModel(title: "Carte(s) bancaire(s)"),
            ItemPanelModel(title: "Compte(s) bancaire(s)"),
            ItemPanelModel(title: "Vérification d'identité"),
            ItemPanelModel(title: "HISTORIQUE FINANCIER"),
            ItemPanelModel(title: "HISTORIQUE PROFESSIONNEL"),
//            ItemPanelModel(title: "MESSAGERIE"),
//            ItemPanelModel(title: "Messages"),
//            ItemPanelModel(title: "Envoyés"),
//            ItemPanelModel(title: "Corbeille"),
            ItemPanelModel(title: "ASSISTANCE"),
            ItemPanelModel(title: "INFORMATIONS"),
            ItemPanelModel(title: ""),
            ItemPanelModel(title: "DÉCONNEXION")

        ]
    }
}
