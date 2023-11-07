import UIKit

// MARK: - PlaceDetailViewController UI Setup
extension PlaceDetailViewController {
    
    // MARK: - Navigation Bar Configuration
    /// Sets up the navigation bar with the title.
    func setupNavigationBar() {
        self.title = "\(searchItem) Details"
    }
    
    // MARK: - Image Loading
    /// Asynchronously loads an image from the view model's icon URL.
    func loadImage() {
        guard let iconURL = viewModel.iconURL else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: iconURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageView.backgroundColor = UIColor.red
                }
            }
        }
    }
    
    // MARK: - ImageView Setup
    /// Configures the properties and layout of the imageView.
    func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
    }
    
    // MARK: - TableView Setup
    /// Sets up the tableView with dataSource, delegate, and registration.
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
    }
    
    // MARK: - Buttons Setup
    /// Initializes the route and photos buttons.
    func setupButtons() {
        setupButton(button: routeButton, title: "Route", selector: #selector(routeButtonTapped))
        setupButton(button: photosButton, title: "Photos", selector: #selector(photosButtonTapped))
    }
    
    /// Configures a button with title, background color, and action selector.
    func setupButton(button: UIButton, title: String, selector: Selector) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
    }
    
    // MARK: - Layout Constraints Setup
    /// Sets up and activates the layout constraints for the views.
    func setupConstraints() {
        // Initialize constraints if they are nil
        imageViewWidthConstraint = imageViewWidthConstraint ?? imageView.widthAnchor.constraint(equalToConstant: 200)
        imageViewHeightConstraint = imageViewHeightConstraint ?? imageView.heightAnchor.constraint(equalToConstant: 200)
        
        // Ensure the constraints are not nil before activating
        guard let imageViewWidthConstraint = imageViewWidthConstraint,
              let imageViewHeightConstraint = imageViewHeightConstraint else {
            fatalError("imageViewWidthConstraint or imageViewHeightConstraint is nil")
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewWidthConstraint,
            imageViewHeightConstraint,
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            routeButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5),
            routeButton.widthAnchor.constraint(equalToConstant: 150),
            routeButton.heightAnchor.constraint(equalToConstant: 40),
            routeButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -2.5),
            routeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photosButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5),
            photosButton.widthAnchor.constraint(equalToConstant: 150),
            photosButton.heightAnchor.constraint(equalToConstant: 40),
            photosButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 2.5),
            photosButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - ImageView Constraints Update
    /// Updates the imageView constraints.
    func updateImageViewConstraints() {
        imageViewWidthConstraint?.isActive = false
        imageViewHeightConstraint?.isActive = false
        
        imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 200)
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 200)
        
        imageViewWidthConstraint?.isActive = true
        imageViewHeightConstraint?.isActive = true
    }
    
    // MARK: - Fetch Data
    /// Fetches the data needed for the cells.
    func fetchData() {
        cellData = viewModel.cellData
    }
}
