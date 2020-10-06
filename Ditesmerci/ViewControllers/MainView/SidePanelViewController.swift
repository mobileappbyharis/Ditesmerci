//
//  SidePanelViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 05/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import FirebaseAuth
class SidePanelViewController: UITableViewController {
    
    var delegate: SidePanelViewControllerDelegate?
    
    var itemsPanel = [ItemPanelModel]()
    
    let cellID = "ItemPanelIdentifier"
    
    var firstName = "none"
    var lastName = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ItemPanelCell.self, forCellReuseIdentifier: cellID)
        itemsPanel = ItemPanelModel.allItemPanel()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsPanel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ItemPanelCell
        switch indexPath.row {
        case 0:
            print("name cell")
            var itemPanel = itemsPanel[indexPath.row]
            itemPanel.title = firstName + " " + lastName
            cell.backgroundColor = .greyNameCellMerci
            cell.nameCellConfiguration(itemPanel)
            break
        case 1, 2, 3, 7, 8, 9, 10:
            print("title cell")
            cell.backgroundColor = .white
            cell.titleCellConfiguration(itemsPanel[indexPath.row])
            break
        case 4, 5, 6:
            print("subtitle cell")
            cell.backgroundColor = .greySubtitleCellMerciAlpha
            cell.subtitleCellConfiguration(itemsPanel[indexPath.row])
            break
        case 11:
            print("empty cell")
            cell.backgroundColor = .greyEmptyCellMerci
            cell.emptyCellConfiguration(itemsPanel[indexPath.row])
            break
        case 12:
            print("deconnexion cell")
            cell.backgroundColor = .black
            cell.deconnexionCellConfiguration(itemsPanel[indexPath.row])
            break
            
            default:
                print("error")
            break
        }
        //cell.configureForItemPanel(itemsPanel[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected item")
        let itemPanel = itemsPanel[indexPath.row]
        print(itemPanel.title)
        delegate?.didSelectItemPanel(itemPanel)
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 || indexPath.item == 15 {
            return 60
        }
        //let height = view.frame.height
        
        return 40
    }
    
}


protocol SidePanelViewControllerDelegate {
    func didSelectItemPanel(_ itemPanel: ItemPanelModel)
}

