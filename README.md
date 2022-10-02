## Book Finder App

사용자가 검색어 (Title, Author 등)를 입력하여 책을 검색하고 결과를 리스트로 표시하는 앱을 만드세요.

### 유저 스토리

- 사용자가 `입력` 필드에 검색어를 입력합니다.
- 사용자가 검색어를 검색하면 특정 데이터(**Title, Author, Published Date, Picture** 등)가 포함된 책 목록을 반환하는 [API를 호출](https://www.notion.so/Book-Finder-App-a764b53f95704f018779deb1af5e2c72)합니다.
- 사용자는 검색된 도서 수와 전체 결과를 모두 볼 수 있습니다. (**페이지네이션**이 가능해야 합니다.)
    - 리스트의 하단에 도달했을 경우 다음 페이지를 불러옵니다. (원티드 앱 채용탭의 공고 목록 처럼 구현)
- 목록에서 각 항목의 자세한 정보가 있는 화면으로 이동합니다.
    - 외부 사이트로 이동하는 링크 추가하거나, 책 상세 화면을 직접 구현해도 됩니다.
    - 제약조건: 웹브라우저 앱으로 오픈하면 안 됩니다.

### 필수 조건

- **언어:** Swift
- **OS:** Deployment Target iOS 14.1
- **아키텍처:** MVVM
- **UI**는 코드로 작성
- **에러** 핸들링을 포함
    
    <aside>
    💡 기타 라이브러리는 자유롭게 사용하셔도 됩니다. 단, 차후 면접에서 사용하신 라이브러리에 대한 질의가 있을 수 있습니다.
    </aside>
    
### 우대 사항

- 로딩 애니메이션 추가
- 유닛 테스트 작성
- MVVM 대신 [Clean Swift](https://clean-swift.com/) 사용

### 예시 화면

<aside>
⚠️ 동일한 UI로 만들 필요는 없습니다.
</aside>

![_2020-01-30__5 30 36](https://user-images.githubusercontent.com/888140/187105781-ca96fc0f-c943-4013-9262-626c33d6c5f3.png)

### 참조

[Google Books APIs](https://developers.google.com/books/docs/overview)

# 구현사항

### 적용기술

* iOS 14.1
* UIKit + SnapKit
* SwiftUI
* MVVM -> VIP
* Alamofire
* RxSwift
* RxAlmofire
* Decodable 모델
* HttpClient 모듈
* HttpRouter 모듈
* Kingfisher
* SkeletonView
* Then

### 구현내용

* `UIKit + SnapKit` 에서 `SwiftUI`로 변경중인 상황을 가정하고 검색화면은 `UIKit`, 상세화면은 `SwiftUI`로 구현
* 무한검색 방지를 위해 쿼리는 `q=intitle`로 제한 (최대 200개 응답)
* 페이지네이션는 `UITableViewDataSourcePrefetching`로 처리
* 로딩 애니메이션은 `TableView + RxSwift + SkeletonView`으로 `실험적`으로 구현
* API 에러는 `.catchAndReturn(.empty)`로 단순처리 후 검색 결과 없음으로 표시
* `MVVM 1차 구현` 후 `VIP로 최종 구현` (UI-Router 제외), 저장소 tag 남김
* `Unit Test` 미구현

### 스크린샷

![Simulator Screen Shot - iPhone 13 Pro - 2022-08-29 at 10 26 30](https://user-images.githubusercontent.com/888140/187108309-44ae84ec-452b-4a61-8c32-b4be881688f5.png)
![Simulator Screen Shot - iPhone 13 Pro - 2022-08-29 at 10 26 23](https://user-images.githubusercontent.com/888140/187108329-d65b52d1-86d1-40d5-82fa-084e0b0bf7ee.png)
