import RxSwift
import RxCocoa

playgroundShouldContinueIndefinitely()

public enum MyError: Error {
    case test
}

class ObamaCareClass {
    let __disposeBag = DisposeBag()
    var disposeBag: DisposeBag! = DisposeBag()
    var disposable: Disposable!
    var observableProbe = ObservableProbe()

    init () {
        observableProbe
            .asObservable()
            .debug("ID:Probe", trimOutput: false)
            .subscribe()
            .addDisposableTo(__disposeBag)
    }
    func sampleWithPublish() {

        let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .publish()

        _ = intSequence
            .subscribe(onNext: { print("Subscription 1:, Event: \($0)") })

        delay(2) { _ = intSequence.connect() }

        delay(4) {
            _ = intSequence
                .subscribe(onNext: { print("Subscription 2:, Event: \($0)") })
        }

        delay(6) {
            _ = intSequence
                .subscribe(onNext: { print("Subscription 3:, Event: \($0)") })
        }
    }

    func testDisposeBag() {
        let mockedService = PublishSubject<String>()

        mockedService
            .debug("ID:Service", trimOutput: false)
            .subscribe()
            .addDisposableTo(disposeBag!)
        delay(1, closure: {
            mockedService.on(.next("A"))
        })
        delay(3, closure: {
            mockedService.on(.next("B"))
        })
    }

    func testDisposable() {
        let mockedService = PublishSubject<String>()
        disposable = mockedService
            .debug("ID:Service", trimOutput: false)
            .subscribe()
        delay(1, closure: {
            mockedService.on(.next("A"))
        })
        delay(3, closure: {
            mockedService.on(.next("B"))
        })
    }

    func testDisposeBagTrackActivity() {
        let mockedService = PublishSubject<String>()

        mockedService
            .trackActivity(observableProbe)
            .debug("ID:Service", trimOutput: false)
            .subscribe()
            .addDisposableTo(disposeBag!)
        delay(1, closure: {
            mockedService.on(.next("A"))
        })
        delay(3, closure: {
            mockedService.on(.next("B"))
        })
    }

    func testDisposableTrackActivity() {
        let mockedService = PublishSubject<String>()
        disposable = mockedService
            .trackActivity(observableProbe)
            .debug("ID:Service", trimOutput: false)
            .subscribe()
        delay(1, closure: {
            mockedService.on(.next("A"))
        })
        delay(3, closure: {
            mockedService.on(.next("B"))
        })
    }
}

var instance: ObamaCareClass! = ObamaCareClass()
instance.testDisposeBagTrackActivity()
delay(2) { () in
    instance = nil
}
//disposeBag()
//disposablee()
//disposeBagTrackActivity()
