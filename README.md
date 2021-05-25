# redash-on-ecs-example

SQL分析ツールredashのECS環境構築のexampleです.

クエリーのスケジューラ化, クエリ結果のAPI化なども可能です.

詳細は以下参照  
https://redash.io/integrations/

## Cloudformation
本レポジトリはRedashのCfn管理を行います.

ただし以下については予期せぬreplace処理を避けるためCfn管理対象外です.

* postgres
* redis
  
また以下については,既に作成済みのためCfn管理対象外としています.  
必要に応じてCfnに組み込んでください.

* VPC                   : 実行環境 
* Route53(HostZoneId)   : RedashのWEB,API用ドメイン
* Certificate Manager   : WEB,API用
* ScurityGroup          : ALB,ECS用

## cli

create db task

`make cfn-deploy-create-db-task ENV=dev`

deploy ecs 

`make cfn-dev-deploy`