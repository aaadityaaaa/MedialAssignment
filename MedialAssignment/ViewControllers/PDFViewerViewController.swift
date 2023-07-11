//
//  PDFViewerViewController.swift
//  MedialAssignment
//
//  Created by Aaditya Singh on 11/07/23.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers

class PDFViewerViewController: UIViewController, PDFViewDelegate {
    
    private lazy var pdfView: PDFView = {
        let view = PDFView()
        view.delegate = self
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap on the + button to browse through your PDFs"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .textLabelColor()
        return label
    }()
    
    private lazy var discardButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(discardButtonTapped(_ :)))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.title = "PDF Viewer"
        view.backgroundColor = .secondarySystemBackground
        showDocumentPicker()
    }
}

extension PDFViewerViewController {
    
    private func setupViews() {
        view.addSubview(pdfView)
        view.addSubview(emptyStateLabel)
        pdfView.pin(edges: .leading(padding: 0), .trailing(padding: 0), .bottom(padding: 0), .safeAreaTop(padding: 0))
        
        emptyStateLabel.pin(edges: .leading(padding: 10), .trailing(padding: -10), .safeAreaTop(padding: 50))
        emptyStateLabel.constrainHeight(equalTo: 50)
        
        let importButton: UIBarButtonItem
        importButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importButtonTapped(_ :)))
        navigationItem.rightBarButtonItem = importButton
        
        navigationItem.leftBarButtonItem = discardButton
        discardButton.isHidden = true
    }
    
}

extension PDFViewerViewController {
    
    @objc private func importButtonTapped(_ sender: UIButton) {
        showDocumentPicker()
    }
    
    @objc private func discardButtonTapped(_ sender: UIButton) {
        pdfView.document = nil
        emptyStateLabel.isHidden = false
    }
    
    private func showDocumentPicker() {
        let documentPicker: UIDocumentPickerViewController
        let pdfType = "com.adobe.pdf"
        
        if #available(iOS 14.0, *) {
            let documentTypes = UTType.types(tag: "pdf", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes, asCopy: true)
        } else {
            documentPicker = UIDocumentPickerViewController(documentTypes: [pdfType], in: .import)
        }
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    private func displayPDF(url: URL) {
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Failed to load the PDF document.")
            return
        }
        pdfView.document = pdfDocument
        pdfView.showsLargeContentViewer = true
        pdfView.autoScales = true
        discardButton.isHidden = false
        emptyStateLabel.isHidden = true
    }
    
}

extension PDFViewerViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        displayPDF(url: url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
