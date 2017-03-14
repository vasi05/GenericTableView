//
//  ItemsTableViewController.swift
//  Medalii
//
//  Created by Vasile Croitoru on 2/8/17.
//  Copyright © 2017 Vasile Croitoru. All rights reserved.
//

import UIKit

struct CellDescriptor {
    let cellClass: UITableViewCell.Type
    let reuseIdentifier: String
    let nibName: String?
    let configure: (UITableViewCell) -> ()
    
    init<Cell: UITableViewCell>(reuseIdentifier: String, nibName: String?, configure: @escaping (Cell) -> ()) {
        self.cellClass = Cell.self
        self.nibName = nibName
        self.reuseIdentifier = reuseIdentifier
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }
}

final class ItemsViewController<Item>: UITableViewController, UINavigationControllerDelegate {
    var items: [Item] = []
    let cellDescriptor: (Item) -> CellDescriptor
    var didSelect: (Item) -> () = { _ in }
    var reuseIdentifiers: Set<String> = []
    var nibNames: Set<String> = []
    var applyNavigationBarTheme: (String?) -> () = {_ in }
    var navBarLeft: (Any) -> () = {_ in }
    var navBarRight: (Any) -> () = {_ in}
    
    init(items: [Item], cellDescriptor: @escaping (Item) -> CellDescriptor) {
        self.cellDescriptor = cellDescriptor
        super.init(style: .plain)
        self.items = items
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyNavigationBarTheme(self.title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didSelect(item)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let descriptor = cellDescriptor(item)
        if !reuseIdentifiers.contains(descriptor.reuseIdentifier) {
            if let nibName = descriptor.nibName {
                tableView.register(UINib.init(nibName: nibName, bundle: nil), forCellReuseIdentifier: descriptor.reuseIdentifier)
                reuseIdentifiers.insert(descriptor.reuseIdentifier)
            }
            else{
                tableView.register(descriptor.cellClass, forCellReuseIdentifier: descriptor.reuseIdentifier)
                reuseIdentifiers.insert(descriptor.reuseIdentifier)
            }

        }
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)
        return cell
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            navBarLeft(items)
        } else{
            print(parent!)
        }
    }
}
