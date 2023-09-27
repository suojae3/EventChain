
---

# 🎉 EventChain 🎉

'Event Chain'은 이벤트를 연속적으로 실행할 수 있도록 설계된 Swift 
라이브러리입니다. <br/>
케이크 만들기와 같이 여러 단계의 작업을 순차적으로 연결할 수 있습니다! 🎂:  
<br/>

<br/>

## 🌟 Features

- **Generic Chain ⛓**: 다양한 타입의 데이터를 생산자에서 생성하고 
소비자에서 사용할 수 있습니다.
- **Type-safe 🔒**: 체인을 통해 유효한 데이터만 연결되도록 타입 검사를 
시행합니다.
- **Descriptive 📖**: 각 이벤트에 대한 로직을 추가함으로써 흐름을 쉽게 
이해할 수 있습니다.

<br/>

## 🛠 Installation

Xcode로 패키지를 직접 추가할 수 있습니다:

1. File > Swift Packages > Add Package Dependency.
2. `https://github.com/suojae3/EventChain.git`.

<br/>

## 🍰 Usage

케이크 만들기를 예로 들어 사용법을 설명해보겠습니다:

### 1. 생산자와 소비자 정의하기:

```swift
// 생산자 기능: 달걀을 휘젓는 것처럼 섞은 달걀을 생성합니다.
func beatEggs() -> String {
    return "Whipped Eggs"
}

// 소비자 기능: 섞인 달걀에 설탕을 넣어줍니다.
func addSugarToEggs(whippedEggs: String) {
    print("Added sugar to \(whippedEggs). Ready for the next step!")
}
```

### 2. Event Chain 인스턴스를 만들어줍니다:

```swift
let cakeMakingChain = EventChainBuilder<String>()

// 체인에 생산자 이벤트와 소비자 이벤트를 추가해줍니다
cakeMakingChain.addProducerEvent("Beat Eggs", event: beatEggs)
cakeMakingChain.addConsumerEvent("Add Sugar", event: addSugarToEggs)

// 체인을 빌드하고 실행합니다
let bakingProcess = cakeMakingChain.build()
bakingProcess()
```

### 3. 체인에 대한 논리 순서를 확인할 수 있습니다:

아래와 같은 예제로 체인이 어떤 논리로 실행되는지 확인할 수 있습니다:

```swift
cakeMakingChain.describeChain()
```

This will print:

```
1. Beat Eggs
2. Add Sugar
```

<br/>

## 🤝 Contributing

문제점이 발견되거나 제안사항이 있으시면 언제든지 이슈나 PR을 열어주세요. 
언제든지 환영합니다! 🙌

---

