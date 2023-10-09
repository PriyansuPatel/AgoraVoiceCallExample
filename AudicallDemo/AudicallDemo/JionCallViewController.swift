//
//  JionCallViewController.swift
//  AudicallDemo
//
//  Created by macOS on 09/10/23.
//

import UIKit
import AgoraRtcKit
import AGEVideoLayout

class JionCallViewController: UIViewController {
    
    
    var agoraKit: AgoraRtcEngineKit!
    var isJoined: Bool = false
    var channelName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = AgoraRtcEngineConfig()
        config.appId = "b1af3503cb604b9aa28f5d2b50ed63e0"
        config.channelProfile = .liveBroadcasting
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    
        let option = AgoraRtcChannelMediaOptions()
        option.publishCameraTrack = false
        option.publishMicrophoneTrack = true
        option.clientRoleType = GlobalSettings.shared.getUserRole()
        NetworkManager.shared.generateToken(channelName: channelName, success: { token in
            let result = self.agoraKit.joinChannel(byToken: token, channelId: self.channelName, uid: 0, mediaOptions: option)
            if result != 0 {
                self.presentAnimatedAlert(message: "joinChannel call failed: \(result), please check your params")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.agoraKit.disableVideo()
        self.agoraKit.enableAudio()
    }
       
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        agoraKit.enable(inEarMonitoring: false)
        agoraKit.disableAudio()
        agoraKit.disableVideo()
        if isJoined {
            agoraKit.leaveChannel { (stats) -> Void in
                self.presentAnimatedAlert(message:  "left channel, duration: \(stats.duration)")
            }
        }
    }
    
    @IBAction func muteButtonClick(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func cloesCall(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}


extension JionCallViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("warning: \(warningCode)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("error: \(errorCode)")
        print("Error \(errorCode) occur")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        self.isJoined = true
        print("Join \(channel) with uid \(uid) elapsed \(elapsed)ms")
    }
    
 
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("remote user join: \(uid) \(elapsed)ms")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("remote user left: \(uid) reason \(reason)")
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
    }
    
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
//        audioViews[0]?.statsInfo?.updateChannelStats(stats)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, localAudioStats stats: AgoraRtcLocalAudioStats) {
//        audioViews[0]?.statsInfo?.updateLocalAudioStats(stats)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats) {
//        audioViews[stats.uid]?.statsInfo?.updateAudioStats(stats)
    }
}
