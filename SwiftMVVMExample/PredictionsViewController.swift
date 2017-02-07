//
//  PredictionsViewController.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 30/01/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

class PredictionsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tooltipLabel: UILabel!
    
    fileprivate let cellIdentifier = "cell"
    
    var viewModel: PredictionSearchViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.placeholder = viewModel?.searchPlaceholderText
        
        tableView.dataSource = self
        
        updateTooltip()
        updatePredictions()
    }
    
    fileprivate func updateTooltip() {
        guard let viewModel = viewModel else {
            return
        }
        
        tooltipLabel.isHidden = !viewModel.displayTooltip
        tooltipLabel.text = viewModel.tooltipText

        tableView.isHidden = !tooltipLabel.isHidden
    }
    
    fileprivate func updatePredictions() {
        tableView.reloadData()
    }
}

extension PredictionsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchText = searchText
    }
}

extension PredictionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel != nil ? viewModel!.cells.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue or create a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        // Fill cell with data
        if let cellViewModel = viewModel?.cells[indexPath.row] {
            cell.textLabel?.attributedText = cellViewModel.name
            cell.detailTextLabel?.text = cellViewModel.types
        }
        
        return cell
    }
}

extension PredictionsViewController: PredictionSearchViewModelDelegate {
    func predictionSearchViewModelDidUpdateTooltip(_ viewModel: PredictionSearchViewModelProtocol) {
        updateTooltip()
    }
    
    func predictionSearchViewModelDidUpdatePredictions(_ viewModel: PredictionSearchViewModelProtocol) {
        updatePredictions()
    }
}
