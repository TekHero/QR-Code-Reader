//
//  ViewController.swift
//  QR Code Reader Test
//
//  Created by Brian Lim on 6/12/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    
    @IBOutlet weak var qrMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            
            let captureMetaDataOutput = AVCaptureMetadataOutput()
            
            captureSession?.addOutput(captureMetaDataOutput)
            
            
            captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            
            view.bringSubview(toFront: qrMessageLabel)
            
            
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView{
                
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        }catch{
            
            print(error)
            return
            
            
        }
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0{
            
            qrCodeFrameView?.frame = CGRect.zero
            qrMessageLabel.text = "No QR Code Found!"
            
            return
            
        }
        
        let metaDataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metaDataObj.type == AVMetadataObjectTypeQRCode{
            
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metaDataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            
            if metaDataObj.stringValue != nil{
                
                qrMessageLabel.text = metaDataObj.stringValue
                
            }
            
            
        }
        
        
        
    }


}

