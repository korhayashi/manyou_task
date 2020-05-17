require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    # 「タスク一覧画面」や「タスク詳細画面」などそれぞれのテストケースで、before内のコードが実行される
    # 各テストで使用するタスクを1件作成する
    # 作成したタスクオブジェクトを各テストケースで呼び出せるようにインスタンス変数に代入
    @task = FactoryBot.create(:task, name: 'task')
  end
  # background do
  #   # あらかじめタスク一覧のテストで使用するためのタスクを二つ作成する
  #   FactoryBot.create(:task)
  #   FactoryBot.create(:second_task)
  # end
  describe 'タスク一覧画面' do
    context 'タスクを作成した場合' do
      it '作成済みのタスクが表示される' do
        # テストで使用するためのタスクを作成
        # task = FactoryBot.create(:task, name: 'task')
        # タスク一覧ページに遷移
        visit root_path
        # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
        # have_contentされているか。（含まれているか。）ということをexpectする（確認・期待する）
        expect(page).to have_content 'task'
        # expectの結果が true ならテスト成功、false なら失敗として結果が出力される
      end
    end
    context 'scopeメソッドで検索をした場合' do
      before do
        task2 = FactoryBot.create(:second_task, name: 'task2')
        task3 = FactoryBot.create(:third_task, name: 'task3')
      end

      it "scopeメソッドでタイトル検索ができる" do
        visit root_path
        fill_in 'search_word', with: 'task'
        click_on '検索'
        # expect(Task.get_by_taskname('task').count).to eq 1
        expect(page).to have_content 'task'
      end
      it "scopeメソッドでステータス検索ができる" do
        visit root_path
        select '着手中', from: 'search_status'
        click_on '検索'
        expect(page).to have_content 'task2'
      end
      it "scopeメソッドで優先度検索ができる" do
        visit root_path
        select '低', from: 'search_priority'
        click_on '検索'
        expect(page).to have_content 'task'
      end
      it "scopeメソッドでタイトルとステータスの両方が検索できる" do
        visit root_path
        fill_in 'search_word', with: 'task3'
        select '完了', from: 'search_status'
        click_on '検索'
        expect(page).to have_content 'task3'
      end
      it "scopeメソッドでタイトルと優先度の両方が検索できる" do
        visit root_path
        fill_in 'search_word', with: 'task3'
        select '高', from: 'search_priority'
        click_on '検索'
        expect(page).to have_content 'task3'
      end
      it "scopeメソッドでステータスと優先度の両方が検索できる" do
        visit root_path
        select '完了', from: 'search_status'
        select '高', from: 'search_priority'
        click_on '検索'
        expect(page).to have_content 'task3'
      end
      it "scopeメソッドでタイトルとステータス、優先度すべてが検索できる" do
        visit root_path
        fill_in 'search_word', with: 'task'
        select '未着手', from: 'search_status'
        select '低', from: 'search_priority'
        click_on '検索'
        expect(page).to have_content 'task'
      end
    end
    context '複数のタスクを作成した場合' do
      it 'タスクが作成日時の降順に並んでいる' do
        # あらかじめタスク並び替えの確認テストで使用するためのタスクを二つ作成する
        # （上記と全く同じ記述が繰り返されてしまう！）
        # task = FactoryBot.create(:task, name: 'task')
        new_task = FactoryBot.create(:task, name: 'new_task')
        visit root_path
        task_list = all('.task_row') # タスク一覧を配列として取得するため、View側でidを振っておく
        expect(task_list[0]).to have_content 'new_task'
        expect(task_list[1]).to have_content 'task'
      end
    end
    context '終了期限を昇順にソート' do
      it 'タスクが終了期限の昇順に並んでいる' do
        # あらかじめタスク並び替えの確認テストで使用するためのタスクを二つ作成する
        new_task = FactoryBot.create(:second_task, name: 'slow_task')
        visit root_path
        # ソートのプルダウンを終了期限が早い順に指定
        # binding.irb
        select '終了期限が早い順', from: 'sort'
        click_button 'ソート'
        task_list = all('.task_row') # タスク一覧を配列として取得するため、View側でidを振っておく
        expect(task_list[0]).to have_content 'task'
        expect(task_list[1]).to have_content 'slow_task'
      end
    end
  end
  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存される' do
        # new_task_pathにvisitする（タスク登録ページに遷移する）
        # 1.ここにnew_task_pathにvisitする処理を書く
        visit new_task_path
        # 「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄に
        # タスクのタイトルと内容をそれぞれfill_in（入力）する
        # 2.ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in '名前', with: 'task2'
        # 3.ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in '詳細', with: 'task2 detail'
        # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
        # 4.「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
        click_on '登録'
        # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
        # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
        # 5.タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
        expect(page).to have_content 'task2'
      end
    end
  end
  describe 'タスク詳細画面' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示されたページに遷移する' do
         # task = FactoryBot.create(:task, name: 'task')
         visit root_path
         click_on '詳細'
         expect(page).to have_content 'task'
       end
     end
  end
end
