//
//  FinalViewController.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//

import UIKit

protocol IFinalViewController: AnyObject {
    func setup(with: FinalViewModel)
    func showActivityIndicator()
    func hideActivityIndicator()
}

final class FinalViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    // MARK: - Properties
    
    private let presenter: IFinalPresenter
    
    // MARK: - Lifecycle
    
    init(presenter: IFinalPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundImageView.alpha = 0
        backButton.alpha = 0
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        presenter.moveBack()
    }
}

// MARK: - Extensions

extension FinalViewController: IFinalViewController {
    func setup(with viewModel: FinalViewModel) {
        titleLabel.text = viewModel.titleText
        messageLabel.text = viewModel.messageText ?? ""
        backgroundImageView.image = viewModel.backgroundImage
        backButton.setTitle(viewModel.buttonText, for: .normal)
        UIView.animate(withDuration: 0.6, delay: 0.1) {
            self.backgroundImageView.alpha = 1
            self.backButton.alpha = 1
        }
    }
    
    func showActivityIndicator() {
        view.showActivityIndicator()
    }
    
    func hideActivityIndicator() {
        view.hideActivityIndicator()
    }
}
