//
//  PredictionsViewController.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 30/01/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

final class PredictionsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tooltipLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    
    private let estimatedRowHeight: CGFloat = 74
    
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.dataSource = self
        tableView.delegate = self
        
        updateTooltip()
        updatePredictions()
        updateLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardToggleNotification(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardToggleNotification(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == seguePlaceDetails {
            // Pass view model to the controller
            if let controller = segue.destination as? PlaceDetailsViewController {
                controller.viewModel = placeDetailsViewModelToShow
            }
        }
    }
    
    
    // MARK: Update view
    
    fileprivate func updateTooltip() {
        tooltipLabel.isHidden = !viewModel!.displayTooltip
        tooltipLabel.text = viewModel!.tooltipText
    }
    
    fileprivate func updatePredictions() {
        tableView.isHidden = !viewModel!.displayTable
        tableView.reloadData()
    }
    
    fileprivate func updateLoadingIndicator() {
        activityIndicator.isHidden = !viewModel!.displayLoadingIndicator
    }
}


// MARK: UISearchBarDelegate
extension PredictionsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchText = searchText
    }
}


// MARK: UITableViewDataSource
extension PredictionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel != nil ? viewModel!.cells.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue or create a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PredictionCell
        
        // Fill cell with data
        if let cellViewModel = viewModel?.cells[indexPath.row] {
            cell.nameLabel?.attributedText = cellViewModel.name
            cell.typeLabel?.text = cellViewModel.types
        }
        
        return cell
    }
}


// MARK: UITableViewDelegate
extension PredictionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Hide section header (view model has nothing to do with this)
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // Hide section footer
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Tell the ViewModel that prediction is selected
        viewModel?.onSelectCell(withIndex: indexPath.row)
    }
}


// MARK: PredictionSearchViewModelDelegate
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
        placeDetailsViewModelToShow = placeDetailsViewModel
        performSegue(withIdentifier: seguePlaceDetails, sender: self)
    }
    
    func predictionSearchViewModelDidUpdateLoadingIndicator(_ viewModel: PredictionSearchViewModelProtocol) {
        updateLoadingIndicator()
    }
}


// MARK: Keyboard events handling
extension PredictionsViewController {
    func onKeyboardToggleNotification(_ notification: Notification) {
        guard let info = notification.userInfo else {
            return
        }
        
        guard let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        // Animate something depends on a new keyboard position
        UIView.animate(withDuration: duration) {
            if notification.name == .UIKeyboardWillShow {
                // Keyboard will show
                // Get keyboard height
                guard let frame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                    return
                }
                self.keyboardWillAppear(with: frame.size)
            } else {
                // .UIKeyboardWillHide
                self.keyboardWillHide()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    // The method will be called within a UIView.animateWithDuration closure
    func keyboardWillAppear(with size: CGSize) {
        constraintBottom.constant = size.height
    }
    
    // The method will be called within a UIView.animateWithDuration closure
    func keyboardWillHide() {
        constraintBottom.constant = 0
    }
}
