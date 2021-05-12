## Setup
```shell
$ tfenv install
- 

$ cd application
```

※まだtfstate管理用のs3を用意してない場合
```
shell
$ cd backend
$ terraform plan
$ terraform apply

# application/provider.tf
# に
# 作成したbacukt名とdynamodb_table名を追記
```

## Development
```
shell
# code format
$ terraform fmt -recursive -diff
```

### Infra
```
shell
$ cd application
$ terraform plan
$ terraform apply
```
