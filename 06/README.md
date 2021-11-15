# ポイントいろいろ

### MVPの全体像

- Passive View
  - フロー同期
- Supervising Controller
  - フロー同期
  - オブザーバー同期

### めも

- フロー同期：```label.text = "hoge"```, ```tableview.reloadData()```みたいな感じ
- オブザーバー同期：都度notification centerとかで伝達するイメージ
- modelはデータがどう扱われるか知らない（プレゼンテーションロジックの切り出し）
- apiなげるのはmodel
- passiveにするにはプロトコルで受け付けるようにする
- passive viewを利用するデメリットとして、簡単な処理でもmodelが絡む処理では「view→presenter→model→presenter→view」という風になりちょっと面倒くさい
- ロジックの冗長性を防ぐならSuperVising、プレゼンテーションロジック全部テストしたいならPassive
- 〇〇Inputプロトコルはその〇〇のファイルの中で継承して、定義するイメージ
- 
