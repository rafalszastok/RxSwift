import RxSwift
import RxCocoa
import RxTest

/*:
 ## Conca (cold + hot)
 Pytania:
 }
 */

example("Concat cold") {
    let scheduler = TestScheduler(initialClock: 0)
    
    let xs1 = scheduler.createColdObservable([
        next(210, 1),
        next(220, 2),
        next(230, 3),
        completed(240),
        ])
    
    let xs2 = scheduler.createColdObservable([
        next(27, 4),
        next(214, 5),
        completed(221),
        ])
    
    let xs3 = scheduler.createColdObservable([
        next(203, 6),
        next(206, 7),
        next(209, 8),
        next(212, 9),
        completed(215)
        ])
    
    let res = scheduler.start {
        Observable.concat([xs1, xs2, xs3].map { $0.asObservable() })
    }
    for event in res.events {
        print("Event at \(event.time)")
        print(event.value)
    }
}


example("Concat hot") {
    let scheduler = TestScheduler(initialClock: 0)
    
    let xs1 = scheduler.createHotObservable([
        next(10, 1),
        next(20, 2),
        next(30, 3),
        completed(40),
        ])
    
    let xs2 = scheduler.createHotObservable([
        next(7, 4),
        next(14, 5),
        completed(21),
        ])
    
    let xs3 = scheduler.createColdObservable([
        next(3, 6),
        next(6, 7),
        next(9, 8),
        next(12, 9),
        completed(15)
        ])
    
    let res = scheduler.start {
        Observable.concat([xs1, xs2, xs3].map { $0.asObservable() })
    }
    for event in res.events {
        print("Event at \(event.time)")
        print(event.value)
    }
}

/*:
 ## Own observable
 Pytania:
 }
 */
extension Observable {
    
    public static func combineAndToArray<O1: ObservableType, O2: ObservableType>
        (_ source1: O1, _ source2: O2, resultSelector: @escaping (O1.E, O2.E) throws -> E)
        -> Observable<[E]> {
            return Observable
                .combineLatest(source1, source2, resultSelector: resultSelector)
                .scan([], accumulator: {$0 + [$1]})
    }
}

func testCombineLatest_Typical2() {
    let scheduler = TestScheduler(initialClock: 0)
    
    let e0 = scheduler.createHotObservable([
        Recorded(time: 240, value: .next(1)),
        Recorded(time: 270, value: .next(12)),
        ])
    
    let e1 = scheduler.createHotObservable([
        Recorded(time: 250, value: .next(10)),
        Recorded(time: 260, value: .next(10)),
        ])
    
    let res = scheduler.start { () -> Observable<[Int]> in
        let result = Observable.combineAndToArray(e0, e1, resultSelector: { (val1, val2) -> Int in
            return val1 + val2
        })
        return result
    }
    
    for event in res.events {
        print("Event at \(event.time)")
        print(event.value)
        print("")
    }
}

example("My RxTest ex1 18dec2016") {
    testCombineLatest_Typical2()
}
