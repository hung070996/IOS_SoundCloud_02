//
//  DatabaseManager.swift
//  SoundCloud
//
//  Created by Do Hung on 7/31/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject {
    static let shared = DatabaseManager()
    var req: NSFetchRequest<NSFetchRequestResult>?
    var context : NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    override init() {}
    
    func checkExistPlaylist(name: String) -> Bool {
        guard let context = context else {
            return false
        }
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Playlist")
        req?.returnsObjectsAsFaults = false
        guard let req = req else {
            return true
        }
        do {
            guard let result = try context.fetch(req) as? [NSManagedObject] else {
                return true
            }
            for r in result {
                if name == r.value(forKey: "name") as? String ?? "" {
                    return true
                }
            }
            return false
        } catch {
            return true
        }
    }
    
    func checkExistTrack(id: Int) -> Bool {
        guard let context = context else {
            return true
        }
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Track")
        req?.returnsObjectsAsFaults = false
        guard let req = req else {
            return true
        }
        do {
            guard let result = try context.fetch(req) as? [NSManagedObject] else {
                return true
            }
            for r in result {
                if id == r.value(forKey: "id") as? Int ?? 0 {
                    return true
                }
            }
            return false
        } catch {
            return true
        }
    }
    
    func checkExistTrackInPlaylist(idTrack: Int, idPlaylist: Int) -> Bool {
        guard let context = context else {
            return true
        }
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Container")
        req?.returnsObjectsAsFaults = false
        guard let req = req else {
            return true
        }
        do {
            guard let result = try context.fetch(req) as? [NSManagedObject] else {
                return true
            }
            for r in result {
                if idTrack == r.value(forKey: "idTrack") as? Int ?? 0
                    && idPlaylist == r.value(forKey: "idPlaylist") as? Int ?? 0 {
                    return true
                }
            }
            return false
        } catch {
            return true
        }
    }
    
    func getNextIDForPlaylist() -> Int {
        guard let context = context else {
            return 0
        }
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Playlist")
        req?.returnsObjectsAsFaults = false
        guard let req = req else {
            return 0
        }
        do {
            let results = try context.fetch(req)
            if results.count > 0 {
                guard let results = results as? [NSManagedObject] else {
                    return 0
                }
                var max = 0
                for result in results {
                    if result.value(forKey: "id") as? Int ?? 0 > max {
                        max = result.value(forKey: "id") as? Int ?? 0
                    }
                }
                return max + 1
            } else {
                return 0
            }
        } catch {
            return 0
        }
    }
    
    func getIDPlaylistByName(name: String) -> Int {
        guard let context = context else {
            return 0
        }
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Playlist")
        req?.returnsObjectsAsFaults = false
        guard let req = req else {
            return 0
        }
        do {
            guard let result = try context.fetch(req) as? [NSManagedObject] else {
                return 0
            }
            if result.count > 0 {
                for r in result {
                    if name == r.value(forKey: "name") as? String ?? "" {
                        return r.value(forKey: "id") as? Int ?? 0
                    }
                }
            } else {
                return 0
            }
        } catch {
            return 0
        }
        return 0
    }
    
    func addPlaylist(name: String) -> Bool {
        guard let context = context else {
            return false
        }
        let plist = NSEntityDescription.insertNewObject(forEntityName: "Playlist", into: context)
        plist.setValue(getNextIDForPlaylist(), forKey: "id")
        plist.setValue(name, forKey: "name")
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func addTrack(track: Track) -> Bool {
        guard let context = context else {
            return false
        }
        let plist = NSEntityDescription.insertNewObject(forEntityName: "Track", into: context)
        plist.setValue(track.id, forKey: "id")
        plist.setValue(track.name, forKey: "name")
        plist.setValue(track.genre, forKey: "genre")
        plist.setValue(track.urlImage, forKey: "urlImage")
        plist.setValue(track.createdAt, forKey: "createdAt")
        plist.setValue(track.des, forKey: "des")
        plist.setValue(track.downloadable, forKey: "downloadable")
        plist.setValue(track.downloadUrl, forKey: "downloadUrl")
        plist.setValue(track.duration, forKey: "duration")
        plist.setValue(track.fullDuration, forKey: "fullDuration")
        plist.setValue(track.kind, forKey: "kind")
        plist.setValue(track.permalinkUrl, forKey: "permalinkUrl")
        plist.setValue(track.streamable, forKey: "streamable")
        plist.setValue(track.title, forKey: "title")
        plist.setValue(track.uri, forKey: "uri")
        plist.setValue(track.urn, forKey: "urn")
        plist.setValue(track.waveformUrl, forKey: "waveformUrl")
        plist.setValue(track.artist, forKey: "artist")
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func addTrackToPlaylist(track: Track, idPlaylist: Int) -> Bool {
        guard let context = context else {
            return false
        }
        let container = NSEntityDescription.insertNewObject(forEntityName: "Container", into: context)
        container.setValue(track.id, forKey: "idTrack")
        container.setValue(idPlaylist, forKey: "idPlaylist")
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func getTrackByID(id: Int) -> Track {
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Track")
        req?.returnsObjectsAsFaults = false
        guard let req = req else {
            return Track()
        }
        do {
            guard let result = try context?.fetch(req) as? [NSManagedObject] else {
                return Track()
            }
            for r in result {
                if id == r.value(forKey: "id") as? Int ?? 0 {
                    return Track(id: r.value(forKey: "id") as? Int ?? 0,
                                 name: r.value(forKey: "name") as? String ?? "",
                                 genre: r.value(forKey: "genre") as? String ?? "",
                                 urlImage: r.value(forKey: "urlImage") as? String ?? "",
                                 createdAt: r.value(forKey: "createdAt") as? String ?? "",
                                 description: r.value(forKey: "des") as? String ?? "",
                                 downloadable: r.value(forKey: "downloadable") as? Bool ?? false,
                                 downloadUrl: r.value(forKey: "downloadUrl") as? String ?? "",
                                 duration: r.value(forKey: "duration") as? Int ?? 0,
                                 fullDuration: r.value(forKey: "fullDuration") as? Int ?? 0,
                                 kind: r.value(forKey: "kind") as? String ?? "",
                                 permalinkUrl: r.value(forKey: "permalinkUrl") as? String ?? "",
                                 streamable: r.value(forKey: "streamable") as? Bool ?? false,
                                 title: r.value(forKey: "title") as? String ?? "",
                                 uri: r.value(forKey: "uri") as? String ?? "",
                                 urn: r.value(forKey: "urn") as? String ?? "",
                                 waveformUrl: r.value(forKey: "waveformUrl") as? String ?? "",
                                 artist: r.value(forKey: "artist") as? String ?? "")
                }
            }
        } catch {
            return Track()
        }
        return Track()
    }
    
    func getListTrackOfPlaylist(idPlaylist: Int) -> [Track] {
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Container")
        req?.returnsObjectsAsFaults = false
        var list = [Track]()
        guard let req = req else {
            return []
        }
        do {
            guard let result = try context?.fetch(req) as? [NSManagedObject] else {
                return [Track]()
            }
            for r in result {
                if idPlaylist == r.value(forKey: "idPlaylist") as? Int ?? 0 {
                    let idTrack = r.value(forKey: "idTrack") as? Int ?? 0
                    list.append(getTrackByID(id: idTrack))
                }
            }
            return list
        } catch {
            return []
        }
    }
    
    func getListPlaylistCustom() -> [Playlist] {
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Playlist")
        req?.returnsObjectsAsFaults = false
        var list = [Playlist]()
        guard let req = req else {
            return []
        }
        do {
            guard let result = try context?.fetch(req) as? [NSManagedObject] else {
                return [Playlist]()
            }
            for r in result {
                if r.value(forKey: "name") as? String ?? "" != "Download"
                    && r.value(forKey: "name") as? String ?? "" != "Favorite" {
                    let id = r.value(forKey: "id") as? Int ?? 0
                    let playlist = Playlist(id: id,
                                            name: r.value(forKey: "name") as? String ?? "",
                                            list: getListTrackOfPlaylist(idPlaylist: id))
                    list.append(playlist)
                }
            }
            return list
        } catch {
            return []
        }
    }
    
    func getListPlaylist() -> [Playlist] {
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Playlist")
        req?.returnsObjectsAsFaults = false
        var list = [Playlist]()
        guard let req = req else {
            return []
        }
        do {
            guard let result = try context?.fetch(req) as? [NSManagedObject] else {
                return [Playlist]()
            }
            for r in result {
                let id = r.value(forKey: "id") as? Int ?? 0
                let playlist = Playlist(id: id,
                                        name: r.value(forKey: "name") as? String ?? "",
                                        list: getListTrackOfPlaylist(idPlaylist: id))
                list.append(playlist)
            }
            return list
        } catch {
            return []
        }
    }
    
    func renamePlaylist(idPlaylist: Int, name: String) -> Bool {
        guard let context = context else {
            return false
        }
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Playlist")
        guard let req = req else {
            return false
        }
        req.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(req)
            for result in results {
                guard let result = result as? NSManagedObject else {
                    return false
                }
                if result.value(forKey: "id") as? Int ?? 0 == idPlaylist {
                    result.setValue(name, forKey: "name")
                }
            }
            do {
                try context.save()
                return true
            } catch
            {
                return false
            }
        } catch {
            return false
        }
    }
    
    func deletePlaylist(idPlaylist: Int) -> Bool {
        guard let context = context else {
            return false
        }
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Playlist")
        guard let req = req else {
            return false
        }
        req.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(req)
            for result in results {
                guard let result = result as? NSManagedObject else {
                    return false
                }
                if result.value(forKey: "id") as? Int ?? 0 == idPlaylist {
                    context.delete(result)
                }
            }
            do {
                try context.save()
                return true
            } catch
            {
                return false
            }
        } catch {
            return false
        }
    }
    
    func deleteTrackFromPlaylist(idTrack: Int, idPlaylist: Int) -> Bool {
        guard let context = context else {
            return false
        }
        req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Container")
        guard let req = req else {
            return false
        }
        req.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(req)
            for result in results {
                guard let result = result as? NSManagedObject else {
                    return false
                }
                if result.value(forKey: "idPlaylist") as? Int ?? 0 == idPlaylist
                    && result.value(forKey: "idTrack") as? Int ?? 0 == idTrack {
                    context.delete(result)
                }
            }
            do {
                try context.save()
                return true
            } catch
            {
                return false
            }
        } catch {
            return false
        }
    }
}
