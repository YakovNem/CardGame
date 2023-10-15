import UIKit
import CoreData

final class CardGameStore {
    
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func fetchPlayers(completion: @escaping ([Player]?, Error?) -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
            do {
                let players = try self.context.fetch(fetchRequest)
                completion(players, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func savePlayer(name: String, score: Int, wins: Int, completion: @escaping (Error?) -> Void) {
        let context = context
        context.perform {
            let player = Player(context: context)
            player.name = name
            player.score = Int32(score)
            player.wins = Int32(wins)
            player.creationDate = Date() 
            
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func fetchLatestPlayer(completion: @escaping (Player?, Error?) -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            fetchRequest.fetchLimit = 1
            do {
                let players = try self.context.fetch(fetchRequest)
                completion(players.first, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func fetchPlayer(withName name: String, completion: @escaping (Player?, Error?) -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            do {
                let players = try self.context.fetch(fetchRequest)
                completion(players.first, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func updatePlayer(_ player: Player, withScore score: Int, wins: Int, completion: @escaping (Error?) -> Void) {
        context.perform {
            player.score = Int32(score)
            player.wins = Int32(wins)
            do {
                try self.context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
}
