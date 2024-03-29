# GROUVE

個人が1からバンドを結成する為のwebアプリケーションです。

「GROUVE」とは、バンドにおいて素晴らしい演奏、心地いいリズムを表す言葉の1つである「GROOVE」と、本アプリの「GROUP」を作るという機能から生まれた造語です。

![logo](https://user-images.githubusercontent.com/95852095/232321606-4af3af6c-fd0f-468f-bbb6-37b216640c0d.png)

様々な条件でユーザーやバンドを検索できる他、スカウト機能によって、ユーザー同士のバンド結成、既存バンドへのメンバー加入、バンド同士の合併等が行えます。

レスポンシブ対応していますので、スマホやタブレットからもご確認可能です。

▼URLはこちら▼
http://portfolio-ryota-matsumoto.herokuapp.com/

# 開発理由
* #### バンドを始めるハードルの高さ
周りに仲間がいない。メンバー間の意識や音楽性が合わない。毎日忙しい。楽器って難しそう。
世の中には憧れを持ちつつも踏み出せない人、埋もれたまま世に出ることのない人が沢山います。

そんな人達の為に、一人からでもバンドを始めやすくできればいいなという思いからこのアプリを開発しました。

* #### 既存の募集サイトの使いにくさ
バンドメンバー募集サイトは数多く存在しますが、アプリ内でできることは限られており使いにくいと感じました。
大半はユーザーの検索や掲示板への募集要項の投稿、個人へのメッセージ機能に留まります。

その為一人一人メンバーを集めていく労力や、既存のバンドに加入することの抵抗感が大きいことでバンド結成に至らないケースが多いです。
そこで、既存の掲示板サイト的アプリではなく、実際にアプリ内でバンドの結成や連絡が気軽に行えるサービスがあればと思いました。

# 使用技術
* Ruby 3.0.5
* Ruby on Rails 7.0.4
* Puma 5.6.5
* Docker 20.10.12
* MySQL 8.0
* AWS S3
* CI/CD CircleCI
* RSpec
* Rubocop
* Heroku

# 機能一覧
- ログイン機能(devise)
  - ゲストログイン機能
  - アイコン画像 動画 音声アップロード機能
  - 各種プロフィールの登録
  - パート、ジャンル選択フォームの表示切替(JQuery)
- パスワードリセット機能(MailGun)
- 検索機能(ransack)
  - 各種条件絞り込み検索
- おすすめ表示機能
  - 各種条件のおすすめユーザー表示
  - 各種条件のおすすめバンド表示
- お気に入り登録・解除機能
  - ユーザー間の登録・解除
  - ユーザー、バンド間の登録・解除
  - お気に入りボタンの非同期での表示切替(turbo-stream)
- スカウト申請機能
  - ユーザー間の申請
  - バンド間の申請
  - ユーザー、バンド間の申請
  - スカウト画面の切り替え(JQuery)
  - スカウト申請ボタン・フォームの活性、非活性(JQuery)
- スカウト承認・拒否機能
- バンド設定機能
  - アイコン画像 動画 音声アップロード機能
  - 各種プロフィール登録機能
  - バンドの平均年齢、最高年齢、最低年齢、人数の自動更新
- バンドリーダー機能
  - メンバーのパート編集
  - リーダーの切替
  - バンドメンバーの除名
- メンバー募集作成機能
  - 募集メンバーの条件設定
- 通知機能
  - 未読の通知を絞り込み
  - 通知ごとにリンクを設定
  - 選択した通知の既読
  - 全ての通知の既読
- バンド内チャット機能
- 画像リサイズ(imagemagick, minimagick)
- ページネーション(kaminari)

# テストフレームワーク
- RSpec
  - factories
  - models spec
  - requests spec
  - system spec

# DB設計
* ### ER図
![ER図](https://user-images.githubusercontent.com/95852095/232289771-cc4a3be9-c78c-4882-abda-ee512a7d5c8c.png)

* ### 各種テーブル
| テーブル名   |     定義    |
| --- | ----------- |
| users | ユーザーの登録情報 |
| user_parts | ユーザーが登録している楽器パートの情報 |
| user_genres    | ユーザーが登録している音楽ジャンルの情報 |
| band | バンドの登録情報 |
| band_genres | バンドが登録している音楽ジャンルの情報 |
| band_members | バンドに所属しているユーザーの情報 |
| recruit_members | バンドが募集しているメンバーの情報 |
| scouts | 申請されたスカウトの情報 |
| favorites | お気に入り登録の情報 |
| notifications | ユーザーに届いた通知の情報 |
| chats | バンド内チャットの情報 |

# インフラ構成図
![インフラ構成図](https://user-images.githubusercontent.com/95852095/232473142-7d43f5fa-8c65-49c1-9836-48f9d3646557.png)

# アプリの特徴
一番の特徴は、アプリ内でバンドを結成できるという点です。
様々な条件でユーザーやバンドを検索し、スカウトを送ることができます。

### 細かく設定できるプロフィール
![ユーザープロフィール](https://user-images.githubusercontent.com/95852095/232309695-1c4c609d-e9eb-47f1-a87b-b6ca62084536.png)

活動方針や活動頻度、曜日、時間帯等を決められる為、条件に合った相手を見つけやすくなっています。

希望パートも三つまで選択可能で、それぞれの熟練度も設定できます。

動画、音源のアップロードも可能なため、実際の演奏を確認することもできます。

### 手軽に相手が見つかるおすすめ表示機能と、しっかり条件を決めたい人の為の詳細検索機能
![ユーザー検索](https://user-images.githubusercontent.com/95852095/232309760-d61c0631-dd94-4877-afa2-f796a72bab45.png)

手軽に相手を見つけたい人の為に、その人に合ったおすすめユーザーを表示する機能を実装しています。

詳細検索機能では、プロフィールで設定した項目に沿って、一つ一つ条件を指定することができます。

![バンド検索](https://user-images.githubusercontent.com/95852095/232309812-6d1509f8-54a4-4d16-9c40-0b9ec5f44e99.png)

バンドのおすすめ表示、詳細検索機能も同様に実装しています。

メンバーの平均年齢や募集しているパートや年代等、詳しく絞り込みを行えます。

### お気に入り登録機能
![ユーザー詳細](https://user-images.githubusercontent.com/95852095/232309827-6d15683b-7eb3-4de7-ba0e-bfab8868872c.png)

他のユーザーや自分の所属していないバンドのプロフィール画面から、お気に入りやスカウトを登録できます。

画面右下のお気に入りボタンを押すことで、「お気に入り済み」と表示が切り替わり、お気に入りへの登録が完了します。

![お気に入り](https://user-images.githubusercontent.com/95852095/232309864-d5a6967c-e64a-407e-8209-b4d02a3ae380.png)

お気に入りの登録、解除と、ボタン表示の切り替えは非同期で行われます(Turbo Streameで実装しています)。

![お気に入り一覧](https://user-images.githubusercontent.com/95852095/232309897-e79b38a2-4b34-4b83-ad9c-aa802d711971.png)

送ったお気に入り及び届いたお気に入りは、お気に入り一覧画面で確認することができます。

### 4種類送れるスカウト機能
![スカウト申請](https://user-images.githubusercontent.com/95852095/232309930-60748c3b-cd23-47af-8d9d-194272d12a99.png)

気になるユーザーやバンドへスカウトを送ることができます。

緑色のタブを切り替えることによって、自分個人からスカウトを送るのか、自分の所属バンドからスカウトを送るのかを選択することができます(JQueryで実装)。

![バンドからスカウト申請](https://user-images.githubusercontent.com/95852095/232309974-97dfb1b7-5c47-4a23-bb11-e905db4ac4b3.png)

バンドからのスカウトは、そのバンドのリーダーでないと送れないようになっています。

また、自分個人からスカウトを送る場合と、スカウト相手がユーザーである場合は、それぞれセレクトボックスからパートの選択を必須としています。

![スカウト一覧](https://user-images.githubusercontent.com/95852095/232310029-1c0ce387-c050-48a7-95e5-3c7038f72fb8.png)
スカウトは、スカウト一覧画面で確認及び承認、拒否が行えます。
届いたスカウト、送ったスカウト共に目的別で確認することができます。

承認ボタンを押すことで、スカウトの内容に沿った処理(バンドの結成、合併、メンバー加入等)が自動的に行われます。

### 編集、募集、連絡等さまざまなバンド内の機能
![所属バンド一覧](https://user-images.githubusercontent.com/95852095/232310052-0240cf74-ec05-4dd5-a7e6-abd4a24570b6.png)

スカウトを通して結成、加入したバンドは、所属バンド一覧ページで確認できます。

![バンド詳細](https://user-images.githubusercontent.com/95852095/232310093-b8476e40-b4ca-4e65-b17c-a6bf104482b1.png)

バンド詳細ページではバンドの基本情報、メンバー情報、募集情報を確認することができます。

基本情報の編集、バンドからの脱退、募集の新規作成などもこの画面から行います。

なお、平均年齢やメンバー数等は、バンドの作成、メンバー加入、脱退時に自動的に更新されます。

![メンバー編集](https://user-images.githubusercontent.com/95852095/232310125-5049a078-84e0-489d-bb6d-0c0fac28ea75.png)

バンドリーダーのみ、メンバーの情報を編集することができます。

具体的には、パートの変更、リーダーの変更、バンドからの除名を行うことができます。

![メンバー募集](https://user-images.githubusercontent.com/95852095/232310247-d0b9d3bd-3c10-4ad6-ad2f-f16b55217506.png)

募集するメンバーを設定することができます。
パート、レベル、年代、性別の項目を設定することが可能です。

![チャット](https://user-images.githubusercontent.com/95852095/232310476-ff3b1528-aae7-458b-8efe-c02c379f5f18.png)

所属バンド一覧の「チャット」ボタンからチャット画面に移ると、バンドメンバー間でメッセージのやりとりを行うことができます。

### 通知機能
![通知](https://user-images.githubusercontent.com/95852095/232310775-e3ca8cee-2f06-4e13-aebd-1de490618b8e.png)
お気に入り、またはスカウトを受けると、通知が届くようになっています。
それぞれどの種類のスカウトなのか、相手は誰なのかを一目で分かるようにしました。

また、お気に入りのスカウトはお気に入り一覧へのリンクを、スカウトの通知はスカウト一覧のリンクを設定することで、届いた通知の詳細を確認できるようになっています。

未読のスカウトのみの表示、全通知を既読にする機能も実装しました。

# こだわり
* #### 開発にはgit-flowを使用し、issuesベースでタスク管理、実装要件はNoteで定義
できる限り実務を想定した開発を行うため、git-flowを使用しました。

![issues](https://user-images.githubusercontent.com/95852095/232322153-f16f989e-8d4c-4d1b-b8de-126d172d2426.png)

また、GitHubのissuesを用いてタスク管理を行い、feature-(issueの番号)ブランチで開発→developへpush
という流れで開発を行いました。

細やかな実装要件は事前にNoteにまとめ、使用技術の選定や実装方法の検討を行いました。

* #### 目的がわかりやすいスカウト機能
ユーザー同士、バンド同士、ユーザーからバンド、バンドからユーザー、全ての組み合わせでスカウトを送り合うことができます。

受け手側にはそれらを区別して表示させることで、送り手がユーザーなのかバンドなのか、また自分に対してなのか自分の所属バンドに対してなのかを一目で分かるようにしました。

また、スカウト時に相手のパートや自分の希望パートを指定、簡単なメッセージを送る等が可能な為、バンド結成に必要な最低限の合意事項を網羅しています。

* #### バンドを組むことの手軽さを追求
上記のスカウト機能によってバンド結成に至る道筋を出来る限り簡略化しました。

また、バンド結成後はいつでも脱退可能にすることや、アプリ内で連絡を取り合えるようにすることで、バンドを組むことのハードルを下げることを意識しました。

バンドメンバー全員がアプリ内のユーザーである為、一人一人の詳細を事前に確認できること、更にそれぞれが元々の知り合いではない為、個人がバンドへ加入することへの抵抗が少ないこともバンド結成へのハードルを下げています。

* #### リーダー機能による秩序の維持
バンドからのスカウト申請や、バンドへのスカウトの承認をリーダーのみが行えることで、同内容のスカウトが重複することや、勝手なスカウトの承認が行われないようにしています。

また、バンドメンバーのパート編集や脱退させる権利、リーダー変更権も付与している為、手軽さの中でも最低限の秩序を保てるようにしています。

# 苦労したところ
* #### CircleCiを通したテスト、デプロイの自動化
Docker、CircleCI、herokuの環境設定は、プログラミングスクールでは学習時間が短かった為、アプリに組み込む際は実装に時間が掛かりました。

一方で自力で調べて実装した為自走力が身に付いた他、理解が深まったと感じています。

* #### DB設計
事前に細かくDB設計や要件定義を行っていなかったことや、Active hash、ポリモーフィック関連付け、fields_forによる子モデルの同時登録を事前に知らなかった為、実装中にテーブル設定が二転三転としました。

準備段階で実装する機能と方法について調べ、方針を固めておくことの重要性を再確認しました。

* #### rails7への対応
rails7での実装に挑戦した為、rails6以前との仕様の違いに何度も躓きました。

deviseがrails7に対応していなかったことや、アセット周りの仕組みを理解することが特に苦労しましたが、新しい技術に対して自力で対応する経験を詰むことができました。

* #### フロントエンドの開発
学習コストと実装のスピード感を重視し、フロントエンドにはBootstrap5、JQueryを採用しました。

それでも、プログラミングスクールではHTML/CSSとjavascriptの基本的な部分しか学習しなかった為、実際にはかなりの時間を費やしました。
