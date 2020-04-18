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
