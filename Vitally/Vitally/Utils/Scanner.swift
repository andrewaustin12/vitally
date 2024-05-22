import SwiftUI
import AVFoundation

struct Scanner: UIViewControllerRepresentable {
    var didFindCode: (String) -> Void
    @Binding var isScanning: Bool

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: Scanner
        var captureSession: AVCaptureSession?

        init(parent: Scanner) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }

                DispatchQueue.main.async {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.parent.didFindCode(stringValue)
                    DispatchQueue.global().async {  // Start running on a background thread
                        self.captureSession?.stopRunning()  // Stop scanning after a barcode is found
                    }
                    self.parent.isScanning = false
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()
        context.coordinator.captureSession = captureSession

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            return viewController
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        if isScanning {
            DispatchQueue.global().async {  // Start running on a background thread
                captureSession.startRunning()
            }
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.global().async {  // Start or stop running on a background thread
            if isScanning {
                context.coordinator.captureSession?.startRunning()
            } else {
                context.coordinator.captureSession?.stopRunning()
            }
        }
    }
}
