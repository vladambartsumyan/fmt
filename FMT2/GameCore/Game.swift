import Foundation
import RealmSwift

class Game {
    
    static let current = Game()
    
    let introductionDigits = [0, 2, 3, 4, 5, 6, 7, 8, 9]
    let numbersForExercises = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    var newGame: Bool {
        return (try! Realm()).objects(StagePassing.self).count == 0
    }
    
    var globalStagesPassing: [GlobalStagePassing] {
        return (try! Realm()).objects(GlobalStagePassing.self).sorted(by: {$0.0.globalStage.type.rawValue < $0.1.globalStage.type.rawValue})
    }
    
    var currentExercise: ExercisePassing? {
        guard let curentGlobalStagePassing = globalStagesPassing.first else {
            return nil
        }
        return curentGlobalStagePassing.currentStagePassing?.currentExercisePassing
    }
    
    var currentGlobalStagePassing: GlobalStagePassing {
        return self.globalStagesPassing.filter{ !$0.isPassed }.first!
    }
    
    func initOnDevice() {
        let allExercises = createExercises()
        let allStages = createStages(allExercises: allExercises)
        let allGlobalStages = [
            GlobalStage.create(stages: [allStages[0], allStages[1]], type: .introduction),
            GlobalStage.create(stages: [allStages[2], allStages[3]], type: .multiplicationBy0),
            GlobalStage.create(stages: [allStages[4], allStages[5]], type: .multiplicationBy1),
            GlobalStage.create(stages: [allStages[6], allStages[7]], type: .multiplicationBy10),
            GlobalStage.create(stages: [allStages[8], allStages[9]], type: .multiplicationBy2),
            GlobalStage.create(stages: [allStages[10], allStages[11]], type: .multiplicationBy3),
            GlobalStage.create(stages: [allStages[12], allStages[13]], type: .multiplicationBy4),
            GlobalStage.create(stages: [allStages[14], allStages[15]], type: .multiplicationBy5),
            GlobalStage.create(stages: [allStages[16], allStages[17]], type: .multiplicationBy6),
            GlobalStage.create(stages: [allStages[18], allStages[19]], type: .multiplicationBy7),
            GlobalStage.create(stages: [allStages[20], allStages[21]], type: .multiplicationBy8),
            GlobalStage.create(stages: [allStages[22], allStages[23]], type: .multiplicationBy9),
            GlobalStage.create(stages: [allStages[24], allStages[25]], type: .permutation)
        ]
        let realm = try! Realm()
        try! realm.write {
            for exercise in allExercises.values {
                realm.add(exercise)
            }
            for stage in allStages {
                realm.add(stage)
            }
            for globalStage in allGlobalStages {
                realm.add(globalStage)
            }
        }
    }
    
    private func createExercises() -> [String : Exercise] {
        var allExercises: [String : Exercise] = [:]
        for digit in introductionDigits {
            allExercises["\(digit)"] = Exercise.create(digit)
        }
        for fst in numbersForExercises {
            for snd in numbersForExercises {
                allExercises["\(fst)x\(snd)"] = Exercise.create(fst, snd)
            }
        }
        return allExercises
    }
    
    private func createStages(allExercises: [String : Exercise]) -> [Stage] {
        let fun = { (arr : [String]) -> [Exercise] in arr.map{ allExercises[$0]! } }
        let allStages: [Stage] = [
            Stage.create(type: .introduction,       mode: .simple, numberOfExercises: 9,  possibleExercises: fun(["0", "2", "3", "4", "5", "6", "7", "8", "9"])),
            Stage.create(type: .introduction,       mode: .exam,   numberOfExercises: 9,  possibleExercises: fun(["0", "2", "3", "4", "5", "6", "7", "8", "9"])),
            
            Stage.create(type: .multiplicationBy0,  mode: .simple, numberOfExercises: 8,  possibleExercises: fun(["2x0", "3x0", "4x0", "5x0", "6x0", "7x0", "8x0", "9x0"])),
            Stage.create(type: .multiplicationBy0,  mode: .exam,   numberOfExercises: 8,  possibleExercises: fun(["2x0", "3x0", "4x0", "5x0", "6x0", "7x0", "8x0", "9x0"])),
            
            Stage.create(type: .multiplicationBy1,  mode: .simple, numberOfExercises: 8,  possibleExercises: fun(["2x1", "3x1", "4x1", "5x1", "6x1", "7x1", "8x1", "9x1"])),
            Stage.create(type: .multiplicationBy1,  mode: .exam,   numberOfExercises: 8,  possibleExercises: fun(["2x1", "3x1", "4x1", "5x1", "6x1", "7x1", "8x1", "9x1"])),
            
            Stage.create(type: .multiplicationBy10, mode: .simple, numberOfExercises: 8,  possibleExercises: fun(["2x10", "3x10", "4x10", "5x10", "6x10", "7x10", "8x10", "9x10"])),
            Stage.create(type: .multiplicationBy10, mode: .exam,   numberOfExercises: 8,  possibleExercises: fun(["2x10", "3x10", "4x10", "5x10", "6x10", "7x10", "8x10", "9x10"])),
            
            Stage.create(type: .multiplicationBy2,  mode: .simple, numberOfExercises: 8,  possibleExercises: fun(["2x2", "2x3", "2x4", "2x5", "2x6", "2x7", "2x8", "2x9"])),
            Stage.create(type: .multiplicationBy2,  mode: .exam,   numberOfExercises: 8,  possibleExercises: fun(["2x2", "2x3", "2x4", "2x5", "2x6", "2x7", "2x8", "2x9"])),
            
            Stage.create(type: .multiplicationBy3,  mode: .simple, numberOfExercises: 7,  possibleExercises: fun(["3x3", "3x4", "3x5", "3x6", "3x7", "3x8", "3x9"])),
            Stage.create(type: .multiplicationBy3,  mode: .exam,   numberOfExercises: 15, possibleExercises: fun(["2x2", "2x3", "2x4", "2x5", "2x6", "2x7", "2x8", "2x9", "3x3", "3x4", "3x5", "3x6", "3x7", "3x8", "3x9"])),
            
            Stage.create(type: .multiplicationBy4,  mode: .simple, numberOfExercises: 6,  possibleExercises: fun(["4x4", "4x5", "4x6", "4x7", "4x8", "4x9"])),
            Stage.create(type: .multiplicationBy4,  mode: .exam,   numberOfExercises: 15, possibleExercises: fun(["2x2", "2x3", "2x4", "2x5", "2x6", "2x7", "2x8", "2x9", "3x3", "3x4", "3x5", "3x6", "3x7", "3x8", "3x9", "4x4", "4x5", "4x6", "4x7", "4x8", "4x9"])),
            
            Stage.create(type: .multiplicationBy5,  mode: .simple, numberOfExercises: 5,  possibleExercises: fun(["5x5", "5x6", "5x7", "5x8", "5x9"])),
            Stage.create(type: .multiplicationBy5,  mode: .exam,   numberOfExercises: 15, possibleExercises: fun(["2x2", "2x3", "2x4", "2x5", "2x6", "2x7", "2x8", "2x9", "3x3", "3x4", "3x5", "3x6", "3x7", "3x8", "3x9", "4x4", "4x5", "4x6", "4x7", "4x8", "4x9", "5x5", "5x6", "5x7", "5x8", "5x9"])),
            
            Stage.create(type: .multiplicationBy6,  mode: .simple, numberOfExercises: 4,  possibleExercises: fun(["6x6", "6x7", "6x8", "6x9"])),
            Stage.create(type: .multiplicationBy6,  mode: .exam,   numberOfExercises: 15, possibleExercises: fun(["2x2", "2x3", "2x4", "2x5", "2x6", "2x7", "2x8", "2x9", "3x3", "3x4", "3x5", "3x6", "3x7", "3x8", "3x9", "4x4", "4x5", "4x6", "4x7", "4x8", "4x9", "5x5", "5x6", "5x7", "5x8", "5x9", "6x6", "6x7", "6x8", "6x9"])),
            
            Stage.create(type: .multiplicationBy7,  mode: .simple, numberOfExercises: 3,  possibleExercises: fun(["7x7", "7x8", "7x9"])),
            Stage.create(type: .multiplicationBy7,  mode: .exam,   numberOfExercises: 15, possibleExercises: fun(["2x2", "2x3", "2x4", "2x5", "2x6", "2x7", "2x8", "2x9", "3x3", "3x4", "3x5", "3x6", "3x7", "3x8", "3x9", "4x4", "4x5", "4x6", "4x7", "4x8", "4x9", "5x5", "5x6", "5x7", "5x8", "5x9", "6x6", "6x7", "6x8", "6x9", "7x7", "7x8", "7x9"])),
            
            Stage.create(type: .multiplicationBy8,  mode: .simple, numberOfExercises: 2,  possibleExercises: fun(["8x8", "8x9"])),
            Stage.create(type: .multiplicationBy8,  mode: .exam,   numberOfExercises: 15, possibleExercises: fun(["2x2", "2x3", "2x4", "2x5", "2x6", "2x7", "2x8", "2x9", "3x3", "3x4", "3x5", "3x6", "3x7", "3x8", "3x9", "4x4", "4x5", "4x6", "4x7", "4x8", "4x9", "5x5", "5x6", "5x7", "5x8", "5x9", "6x6", "6x7", "6x8", "6x9", "7x7", "7x8", "7x9", "8x8", "8x9"])),
            
            Stage.create(type: .multiplicationBy9,  mode: .simple, numberOfExercises: 1,  possibleExercises: fun(["9x9"])),
            Stage.create(type: .multiplicationBy9,  mode: .exam,   numberOfExercises: 15, possibleExercises: fun(["2x2", "2x3", "2x4", "2x5", "2x6", "2x7", "2x8", "2x9", "3x3", "3x4", "3x5", "3x6", "3x7", "3x8", "3x9", "4x4", "4x5", "4x6", "4x7", "4x8", "4x9", "5x5", "5x6", "5x7", "5x8", "5x9", "6x6", "6x7", "6x8", "6x9", "7x7", "7x8", "7x9", "8x8", "8x9", "9x9"])),
            
            Stage.create(type: .permutation,        mode: .simple, numberOfExercises: 28, possibleExercises: fun(["3x2", "4x2", "5x2", "6x2", "7x2", "8x2", "9x2", "4x3", "5x3", "6x3", "7x3", "8x3", "9x3", "5x4", "6x4", "7x4", "8x4", "9x4", "6x5", "7x5", "8x5", "9x5", "7x6", "8x6", "9x6", "8x7", "9x7", "9x8"])),
            Stage.create(type: .permutation,        mode: .exam,   numberOfExercises: 15, possibleExercises: fun(["3x2", "4x2", "5x2", "6x2", "7x2", "8x2", "9x2", "4x3", "5x3", "6x3", "7x3", "8x3", "9x3", "5x4", "6x4", "7x4", "8x4", "9x4", "6x5", "7x5", "8x5", "9x5", "7x6", "8x6", "9x6", "8x7", "9x7", "9x8"]))            
        ]
        allStages.forEach{stage in stage.possibleExercises.forEach{ $0.type = stage.type }}
        return allStages
    }
    
    func reset() {
        let realm = try! Realm()
        try! realm.write {
            self.introductionDigits.forEach { digit in
                let digitObject = DigitColor()
                digitObject.value = digit
                digitObject.color = .clear
                realm.add(digitObject, update: true)
            }
            realm.delete(realm.objects(ElapsedTime.self))
            realm.delete(realm.objects(GameError.self))
            realm.delete(realm.objects(ExercisePassing.self))
            realm.delete(realm.objects(StagePassing.self))
            realm.delete(realm.objects(GlobalStagePassing.self))
        }
        ServerTaskManager.pushBack(ServerTask.startGame())
    }
    
    func createGame() {
        let realm = try! Realm()
        let allGlobalStages = realm.objects(GlobalStage.self).sorted(byKeyPath: "_type")
        var globalStagesPassing: [GlobalStagePassing] = []
        for globalStage in allGlobalStages {
            globalStagesPassing.append(globalStage.createGlobalStagePassing())
        }
        try! realm.write {
            for globalStagePassing in globalStagesPassing {
                for stagePassing in globalStagePassing.stagesPassing {
                    for exercisePassing in stagePassing.exercises {
                        realm.add(exercisePassing)
                    }
                    realm.add(stagePassing)
                }
                realm.add(globalStagePassing)
            }
        }
    }
    
    func setColor(_ color: Color, forDigit digit: Int) {
        let realm = try! Realm()
        ServerTaskManager.pushBack(ServerTask.setColorForDigit(color: color, digit: digit))
        let digitObject = realm.object(ofType: DigitColor.self, forPrimaryKey: digit)!
        try! realm.write {
            digitObject.color = color
        }
    }
    
    func getColor(forDigit digit: Int) -> Color {
        if digit == 1 || digit == 10 {
            return .clear
        }
        guard introductionDigits.contains(digit) else {
            fatalError("\(digit) do not stored in database.")
        }
        return (try! Realm()).object(ofType: DigitColor.self, forPrimaryKey: digit)!.color
    }    
}
