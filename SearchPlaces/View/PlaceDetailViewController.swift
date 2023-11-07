import UIKit

// MARK: - PlaceDetailViewController Declaration
class PlaceDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var detailView: UIImageView!

    // MARK: - Properties
    var searchItem = ""
    var placeListArrayDetail: [String: Any] = [:]
    var cellData: [(String, String)] = []

    var imageViewWidthConstraint: NSLayoutConstraint?
    var imageViewHeightConstraint: NSLayoutConstraint?
    var viewModel: PlaceDetailViewModel!

    // MARK: - Subviews
    let imageView = UIImageView()
    let tableView = UITableView()
    let routeButton = UIButton()
    let photosButton = UIButton()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        loadImage()
        setupImageView()
        setupTableView()
        setupButtons()
        setupConstraints()
        fetchData()
        updateFinalImageViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Setup Methods
    // (Add setup methods here)

    // MARK: - Table View DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let (label1Text, label2Text) = cellData[indexPath.row]
        cell.textLabel?.text = label1Text
        cell.detailTextLabel?.text = label2Text
        updateCellFont(cell: cell)
        return cell
    }

    // MARK: - Table View Delegate
    // (Add delegate methods here if any)

    // MARK: - Orientation Changes Handling
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.tableView.reloadData()
        }
    }

    // MARK: - Cell Configuration
    func updateCellFont(cell: UITableViewCell) {
        cell.textLabel?.numberOfLines = 0  // This allows the label to display an unlimited number of lines.
        cell.textLabel?.lineBreakMode = .byWordWrapping  // This wraps the text within the label.
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if UIDevice.current.userInterfaceIdiom == .pad {
                if scene.interfaceOrientation.isPortrait {
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
                    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 30)



                } else {
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
                }
            } else {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            }
        }
    }

    // MARK: - Font Size Update for Cells
    func updateFontSizeForVisibleCells() {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in visibleIndexPaths {
                if let cell = tableView.cellForRow(at: indexPath) {
                    updateCellFont(cell: cell)
                }
            }
        }
    }

}
