//
//  ItemPanelCell.swift
//  Ditesmerci
//
//  Created by 7k04 on 05/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit


class ItemPanelCell: UITableViewCell {
    
    let titleItemPanelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = ""
        return label
    }()
    
    func nameCellConfiguration(_ itemPanel: ItemPanelModel) {
        titleItemPanelLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleItemPanelLabel.textColor = .black

        titleItemPanelLabel.text = itemPanel.title
    }
    
    func titleCellConfiguration(_ itemPanel: ItemPanelModel) {
        titleItemPanelLabel.font = UIFont.systemFont(ofSize: 15)
        titleItemPanelLabel.textColor = .black

        titleItemPanelLabel.text = itemPanel.title
    }
    
    func subtitleCellConfiguration(_ itemPanel: ItemPanelModel) {
        titleItemPanelLabel.font = UIFont.italicSystemFont(ofSize: 15)
        titleItemPanelLabel.textColor = .black

        titleItemPanelLabel.text = itemPanel.title
    }
    
    func emptyCellConfiguration(_ itemPanel: ItemPanelModel) {
        titleItemPanelLabel.text = itemPanel.title
    }
    
    func deconnexionCellConfiguration(_ itemPanel: ItemPanelModel) {
        titleItemPanelLabel.font = UIFont.systemFont(ofSize: 16)
        titleItemPanelLabel.textColor = .white
        titleItemPanelLabel.text = itemPanel.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }

    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews(){
        addSubview(titleItemPanelLabel)
        
        NSLayoutConstraint.activate([
            titleItemPanelLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleItemPanelLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            ])
        
    }
}
