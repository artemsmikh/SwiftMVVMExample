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
    
    fileprivate let seguePlaceDetails = "placeDetails"
    
    var viewModel: PredictionSearchViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    fileprivate var placeDetailsViewModelToShow: PlaceDetailsViewModelProtocol? = nil
    
    
    // MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.placeholder = viewModel?.searchPlaceholderText
        
        tableView.dataSource = self
        tableView.delegate = self
        
        updateTooltip()
        updatePredictions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == seguePlaceDetails {
            // Pass view model to the controller
            if let controller = segue.destination as? PlaceDetailsViewController {
                controller.viewModel = self.placeDetailsViewModelToShow
            }
        }
    }
    
    
    // MARK: Update view
    
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
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        // Fill cell with data
        if let cellViewModel = viewModel?.cells[indexPath.row] {
            cell!.textLabel?.attributedText = cellViewModel.name
            cell!.detailTextLabel?.text = cellViewModel.types
        }
        
        return cell!
    }
}

extension PredictionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Hide section header (view model has nothing to do with this)
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Tell the ViewModel that prediction is selected
        self.viewModel?.onSelectCell(withIndex: indexPath.row)
    }
}

extension PredictionsViewController: PredictionSearchViewModelDelegate {
    func predictionSearchViewModelDidUpdateTooltip(_ viewModel: PredictionSearchViewModelProtocol) {
        updateTooltip()
    }
    
    func predictionSearchViewModelDidUpdatePredictions(_ viewModel: PredictionSearchViewModelProtocol) {
        updatePredictions()
    }
    
    func predictionSearchViewModel(_ viewModel: PredictionSearchViewModelProtocol, showPlaceDetails placeDetailsViewModel: PlaceDetailsViewModelProtocol) {
        // Show a controller with the details of the selected place
        // We'll pass the ViewModel for that controller in prepareForSegue method
        self.placeDetailsViewModelToShow = placeDetailsViewModel
        self.performSegue(withIdentifier: seguePlaceDetails, sender: self)
    }
}
