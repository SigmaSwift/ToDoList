//
//  NoteListView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

extension NoteListView: INoteListView {
    func show(_ notes: [Note]) {
        self.notes = notes
        applySnapshot(notes: notes)
    }
}

final class NoteListView: UIViewController {
    var presenter: INoteListPresenter?
    
    private var tableView: UITableView = .init()
    private let searchBar: SearchBar = .init()
    private var footerView: UIView = .init()
    private var totalLabel: UILabel = .init()
    
    private let footerViewHeight: CGFloat = 100
    
    private var notes: [Note] = []
    private var filteredNotes: [Note] = []
    
    enum Section {
        case main
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, Note>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoaded()
        
        view.backgroundColor = DesignSystem.Color.primaryBlack
        tableView.backgroundColor = DesignSystem.Color.primaryBlack
        tableView.separatorColor = DesignSystem.Color.secondaryGray
        footerView.backgroundColor = DesignSystem.Color.primaryGray
        
        configureHeader()
        configureTableView()
        configureDataSource()
        configureFooter()
    }
    
    private func configureHeader() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        searchBar.textDidChanged = { [weak self] input in
            guard let self else { return }
            
            if input.isEmpty {
                applySnapshot(notes: notes, animatingDifferences: true)
            } else {
                let filteredNotes = notes.filter { $0.todo.lowercased().contains(input.lowercased()) }
                applySnapshot(notes: filteredNotes, animatingDifferences: true)
            }
        }
    }
    
    private func configureFooter() {
        let addNoteButton = UIButton(type: .system)
        addNoteButton.setImage(.init(systemName: "square.and.pencil"), for: .normal)
        addNoteButton.tintColor = DesignSystem.Color.darkYellow
        addNoteButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        let spacer = UIView()
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .equalCentering
        hStack.addArrangedSubview(spacer)
        hStack.addArrangedSubview(totalLabel)
        hStack.addArrangedSubview(addNoteButton)
               
        footerView.addSubview(hStack)
        view.addSubview(footerView)
        
        [ footerView, hStack ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let padding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            footerView.heightAnchor.constraint(equalToConstant: footerViewHeight),
            footerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            footerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hStack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: padding),
            hStack.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -padding),
            hStack.topAnchor.constraint(equalTo: footerView.topAnchor, constant: padding)
        ])
    }
    
    // MARK: - Table view -
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .init(top: 10, left: 20, bottom: 10, right: 20)
        tableView.backgroundColor = .black
   
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -footerViewHeight)
        ])
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Note>(tableView: tableView) { tableView, indexPath, note in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteCell else { return NoteCell() }
                    
            cell.configure(with: note)
            cell.backgroundColor = DesignSystem.Color.primaryWhite
            
            return cell
        }
    }
    
    private func applySnapshot(notes: [Note], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        snapshot.appendSections([.main])
        snapshot.appendItems(notes)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func showContextMenu(on note: Note) {
        guard let superView = navigationController?.view else { return }
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = .zero
        superView.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: superView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
        
        let contentView = blurView.contentView
        
        let contextMenuView = createContextMenu(
            title: note.title ?? String(note.id),
            description: note.todo,
            date: note.date
        )
        contextMenuView.translatesAutoresizingMaskIntoConstraints = false
        contextMenuView.alpha = .zero
        contentView.addSubview(contextMenuView)
        
        NSLayoutConstraint.activate([
            contextMenuView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contextMenuView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contextMenuView.widthAnchor.constraint(equalToConstant: 320)
        ])
        
        let alert = Alert()
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.alpha = .zero
        alert.set(models: [
            .init(text: "Edit", image: "square.and.pencil", action: .edit),
            .init(text: "Share", image: "square.and.arrow.up", action: .share),
            .init(text: "Delete", image: "trash.slash", action: .delete, tint: .red)
        ])
        
        contentView.addSubview(alert)
        
        NSLayoutConstraint.activate([
            alert.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            alert.topAnchor.constraint(equalTo: contextMenuView.bottomAnchor, constant: 20),
            alert.widthAnchor.constraint(equalToConstant: 254)
        ])
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            [ blurView, contextMenuView, alert ].forEach { $0.alpha = 1 }
        }
        
        contentView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(dismissContextMenu)
        ))
        
        alert.didTap = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .edit:
                dismissContextMenu()
                presenter?.didTapOn(note, isEditable: true)
            case .delete:
                presenter?.delete(note.id)
            case .share:
                // No need to implemeted
                print("Share")
            }
        }
    }
        
    private func createContextMenu(
        title: String,
        description: String,
        date: String
    ) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 10
        container.backgroundColor = UIColor.init(hex: "#272729")
        
        let titleLabel = UILabel()
        titleLabel.text = title
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        
        let dateLabel = UILabel()
        dateLabel.text = date
        
        [ titleLabel, descriptionLabel, dateLabel ].forEach { $0.textColor = .white }
        
        let vStack = UIStackView(arrangedSubviews: [ titleLabel, descriptionLabel, dateLabel ])
        vStack.axis = .vertical
        vStack.spacing = 6
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(vStack)
        
        let padding: CGFloat = 14
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            vStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            vStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
            vStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding)
        ])
        
        return container
    }
    
    // MARK: - Actions -
    
    @objc
    private func addNoteTapped() {
        presenter?.addNote()
    }
    
    private func didTap(_ note: Note, isEditable: Bool) {
        presenter?.didTapOn(note, isEditable: isEditable)
    }
    
    @objc
    private func dismissContextMenu() {
        if let blurView = navigationController?.view.subviews.last {
            UIView.animate(withDuration: 0.15) {
                blurView.alpha = 0
            } completion: { _ in
                blurView.removeFromSuperview()
            }
        }
    }
    
    @objc
    private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if let note = dataSource.itemIdentifier(for: indexPath) {
                    showContextMenu(on: note)
                }
            }
        }
    }
}

extension NoteListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let note = dataSource.itemIdentifier(for: indexPath) {
            didTap(note, isEditable: false)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

struct DesignSystem {
    enum Color {
        static let primaryGray = UIColor(hex: "#272729")
        static let secondaryGray = UIColor(hex: "#4D555E")
        
        static let primaryWhite = UIColor(hex: "#F4F4F4")
        static let primaryBlack = UIColor(hex: "#040404")
        
        static let darkYellow = UIColor(hex: "#FED702")
    }
}
