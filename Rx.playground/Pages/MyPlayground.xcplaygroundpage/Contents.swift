import RxSwift
import RxCocoa
import RxTest

public enum MyError: Error {
    case test
}

/*:
 ## CombineLatest & Zip
 Pytanie: Jak łączone będą wyniki
 */

typealias CombiningClosure = (
    (Observable<String>, Observable<String>)
    -> Observable<String>)

func combiningEx1(combiningClosure: CombiningClosure) {
    let disposeBag = DisposeBag()
    let subjectLetters = PublishSubject<String>()
    let subjectDigits = PublishSubject<String>()
    
    let combined = combiningClosure(subjectLetters.asObservable(),
                                    subjectDigits.asObservable())
    combined.subscribe(onNext: { print( $0)})
    subjectLetters.onNext("A")
    subjectLetters.onNext("B")
    subjectLetters.onNext("C")
    subjectDigits.onNext("1")
    subjectDigits.onNext("2")
    subjectDigits.onNext("3")
    subjectDigits.onNext("4")
    subjectDigits.onNext("5")
    subjectLetters.onNext("D")
}

example("My combineLatest ex1 14dec2016") {
    let combiningClosure: CombiningClosure = {
        Observable.combineLatest($0, $1, resultSelector: {$0 + $1})
    }
    combiningEx1(combiningClosure: combiningClosure)
}

example("My zip ex1 14dec2016") {
    let combiningClosure: CombiningClosure = {
        Observable.zip($0, $1, resultSelector: {$0 + $1})
    }
    combiningEx1(combiningClosure: combiningClosure)
}

func combiningEx2(combiningClosure: CombiningClosure) {
    let disposeBag = DisposeBag()
    let subjectLetters = PublishSubject<String>()
    let subjectDigits = PublishSubject<String>()
    
    let combined = combiningClosure(subjectLetters.asObservable(),
                                    subjectDigits.asObservable())
    combined.subscribe(onNext: { print( $0)},
                       onError: { print( "Error \($0)")})
    subjectLetters.onNext("A")
    subjectDigits.onNext("1")
    subjectDigits.onNext("2")
    subjectDigits.onError(MyError.test)
    subjectDigits.onNext("3")
    subjectLetters.onNext("B")
}

example("My combineLatest ex1 14dec2016") {
    let combiningClosure: CombiningClosure = {
        Observable.combineLatest($0, $1, resultSelector: {$0 + $1})
    }
    combiningEx2(combiningClosure: combiningClosure)
}

example("My zip ex1 14dec2016") {
    let combiningClosure: CombiningClosure = {
        Observable.zip($0, $1, resultSelector: {$0 + $1})
    }
    combiningEx2(combiningClosure: combiningClosure)
}

/*:
 Replay example
 */

example("My replay 13dec2016") {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<Int>()
    let observable = subject
        .asObservable()
        .replay(2)
    delay(2, closure: {
        observable
            .connect()
    })
    
    observable
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
    subject.onNext(1)
    subject.onNext(2)
    delay(3, closure: {
        subject.onNext(3)
    })
}
/*:
 ## Concat
 Pytania:
 1. Czy jabłko zostanie wypisane na ekran?
 2. Świnia, królik, kot. Które zostanie wypisane na ekran?
 3. Co stanie się, kiedy zamienię concat na merge?
 */
example("RxExample:concat") {
    let disposeBag = DisposeBag()
    
    let subject1 = BehaviorSubject(value: "🍎")
    let subject2 = BehaviorSubject(value: "🐶")
    
    let variable = Variable(subject1)
    
    variable.asObservable()
        .concat()
        .subscribe { print($0) }
        .addDisposableTo(disposeBag)
    
    subject1.onNext("🍐")
    subject1.onNext("🍊")
    
    variable.value = subject2
    
    subject2.onNext("🐖?")
    subject2.onNext("🐇?")
    subject2.onNext("🐱?")
    subject1.onCompleted()
    
    
    subject2.onNext("🐭")
}

/*:
 ## asDriver problem
 Pytanie: Co zostanie wypisane na ekran?
 Wykonujemy dispose na subject zanim wszystkie zdarzenia zostaną wykonane.
 Driver przełącza schedulera na MainScheduler (main dispatch queue).
 Wynik otrzymamy w kolejnym przejściu.
 */

example("Slack: scotegg 13dec2016") {
    
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<Int>()
    subject
        //                .catchErrorJustReturn(100)
        .asDriver(onErrorRecover: { (error) in
            print("Error:", error)
            return Driver.just(1000)
        })
        //        .debug()
        .drive(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
    
    subject.onNext(1)
    subject.onNext(2)
    subject.onError(MyError.test)
    
    subject.onNext(3)
    //    RunLoop.current.run(until: Date().addingTimeInterval(0.1))
}
