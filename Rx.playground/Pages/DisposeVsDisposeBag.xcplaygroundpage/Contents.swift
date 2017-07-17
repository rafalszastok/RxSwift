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
    let dateFormatter = DateFormatter()
    let randomString = "Al Capone"

    init () {
        observableProbe
            .asObservable()
            .debug("ID:Probe", trimOutput: false)
            .subscribe()
            .addDisposableTo(__disposeBag)
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
            .subscribe(onNext: { [unowned self] (str) in
                print("Event next \(str)")
                print("RandomStr \(self.randomString)")

            })
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
    deinit {
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss:SSS"
        print("\(dateFormatter.string(from: Date())): DEINIT CALLED")
    }
}

var instance: ObamaCareClass! = ObamaCareClass()
//instance.testDisposeBag()
instance.testDisposable()
//instance.testDisposeBagTrackActivity()
//instance.testDisposableTrackActivity()
delay(2) { () in
    instance = nil
}
