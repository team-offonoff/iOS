## Tech
---

### Combine
---
- 비동기 프로그래밍
- @Published, AnyPublisher, PassthroughSubject 등을 활용하였으며, Publisher 종류별로 언제 사용하는 것이 적합한지에 대해 고민해보았습니다. 

### URLSession
---
- API 연동
- 프로토콜을 활용하여 중복 코드를 최소화한 네트워크 레이어를 구성하였습니다. 

### Modular Architecture
----
- 클린 아키텍처를 기반으로 모듈화하였습니다.
- 협업 시 유용합니다. 
- 접근 제어를 통해 다른 모듈에게 클래스, 메서드 등 불필요한 노출을 방지합니다.

### Clean Architecture
---
- Data Layer : DTO와 Repository를 가지며, 서버로 데이터를 전송하거나, 데이터를 받아오는 책임을 가지고 있습니다.
- Domain Layer : 앱의 비즈니스 로직을 담당합니다. UseCase, Entity, Repository Interface를 가지며, 엡의 비즈니스 로직을 담당하게 됩니다.
- Presentaion Layer : UI 로직에 대한 책임을 가집니다. 

### MVVM Pattern
---
- 책임을 기반으로 View Model을 설계하였습니다. 
- 의존 역전 규칙을 준수하기 위해 protocol을 통해 인터페이스를 설계하였습니다.

### Coordinator Pattern
---
- 화면 전환을 담당합니다. 
- View Controller 간 의존성을 제거할 수 있습니다. 

## Tuist Graph
---

<img src= ./graph.png  width="400" />

- RootFeature: 각 Feature를 하나로 이어주는 모듈로, TabController가 구현되어 있음.
- _Feature: View, ViewController, ViewModel 
- _FeatureInterface: 각 Feature의 Coordinator 인터페이스, ViewModel 인터페이스 등 선언
- ABKit: A/B 디자인 시스템
- FeatureDependency: BaseViewController, Coordinator 프로토콜
- Data: DTO, RepositoryImpl 
- Domain: Entity, Repository Interface, Use Case
- Core: Network, extension 선언 등
- ThirdPartyLibs: 외부 라이브러리


## Library
---
- SnapKit: 코드 베이스 UI를 구현합니다. 
