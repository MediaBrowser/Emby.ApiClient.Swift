//
//  RecordingStatus.swift
//  Emby.ApiClient
//

import Foundation

public enum RecordingStatus: String {
    case New
    case Scheduled
    case InProgress
    case Completed
    case Aborted
    case Cancelled
    case ConflictedOk
    case ConflictedNotOk
    case Error
}