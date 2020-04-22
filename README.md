### Userテーブル
  - id (int)  
  - name (str)  
  - email (str)  
  - password_digest (str)

### Taskテーブル
  - id (int)  
  - name (str)  
  - detail (text)
  - priority (str)

### Labelテーブル
  - id (int)  
  - user_id (int)(FK)  
  - task_id (int)(FK)
---------------------------

### herokuデプロイ手順
  - （git commitがまだであれば）
  > git add -A
  > git commit -m "commit message"

  - heroku create
  - git push heroku master
  - heroku run rails db:migrate
----------------------------

#### バージョン情報
  - ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin19]
  - Rails 5.2.4.2
  - psql (PostgreSQL) 12.2
