//
//  PitchesTableViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/6/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

protocol PitchesTableViewControllerDelegate {
    func setNumberOfRows(_ rows: Int)
}

class PitchesTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    var delegate: PitchesTableViewControllerDelegate?
    let pitchOffsets = DataManager.today().filteredPitchOffsets

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        darkModeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeChanged), name: .darkModeChanged, object: nil)
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        tableView.separatorColor = darkModeOn ? UIColor.darkPitchPipeBackground : UIColor.separatorColor
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = min(pitchOffsets.count, 5)
        delegate?.setNumberOfRows(rows)
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PitchesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "pitchCell", for: indexPath) as! PitchesTableViewCell
        cell.numberLabel.text = "\(indexPath.row + 1)."
        
        let offsetData = pitchOffsets[indexPath.row]
        cell.pitchLabel.text = "\(offsetData.pitch.description)\(offsetData.pitch.octave)"
        cell.updateCentsLabel(cents: offsetData.averageOffset.roundTo(places: 1))
        
        return cell
    }
    
}
