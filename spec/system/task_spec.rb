require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  def user_login
    visit new_session_path
    fill_in 'session[email]', with: 'sample@example.com'
    fill_in 'session[password]', with: '00000000'
    click_button 'ログイン'
  end

  before do
    # 「タスク一覧画面」や「タスク詳細画面」などそれぞれのテストケースで、before内のコードが実行される
    # 各テストで使用するタスクを1件作成する
    # 作成したタスクオブジェクトを各テストケースで呼び出せるようにインスタンス変数に代入
    @label1 = FactoryBot.create(:label)
    @label2 = FactoryBot.create(:second_label)
    @user = FactoryBot.create(:user)
    @admin_user = FactoryBot.create(:admin_user)

    user_login
  end
  # background do
  #   # あらかじめタスク一覧のテストで使用するためのタスクを二つ作成する
  #   FactoryBot.create(:task)
  #   FactoryBot.create(:second_task)
  # end
  describe 'タスク一覧画面' do
    before do
      @task = FactoryBot.create(:task, name: 'task')
      @task2 = FactoryBot.create(:second_task, name: 'task2')
      @task3 = FactoryBot.create(:third_task, name: 'task3')
      @labeling1 = FactoryBot.create(:labeling)
      @labeling2 = FactoryBot.create(:second_labeling)
    end
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
      it "scopeメソッドでラベル検索ができる" do
        visit root_path
        select 'A', from: 'search_label'
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
        sleep 1
        expect(page).to have_content 'task3'
      end
      it "scopeメソッドでステータスと優先度の両方が検索できる" do
        visit root_path
        select '未着手', from: 'search_status'
        sleep 1
        select '低', from: 'search_priority'
        click_on '検索'
        # binding.irb
        expect(page).to have_content 'task'
      end
      it "scopeメソッドでタイトルとステータス、優先度、ラベルすべてが検索できる" do
        visit root_path
        fill_in 'search_word', with: 'task'
        select '未着手', from: 'search_status'
        select '低', from: 'search_priority'
        select 'A', from: 'search_label'
        sleep 1
        click_on '検索'
        expect(page).to have_content 'task'
      end
    end
    context '複数のタスクを作成した場合' do
      it 'タスクが作成日時の降順に並んでいる' do
        # あらかじめタスク並び替えの確認テストで使用するためのタスクを二つ作成する
        # （上記と全く同じ記述が繰り返されてしまう！）
        visit root_path
        task_list = all('.task_row') # タスク一覧を配列として取得するため、View側でidを振っておく
        expect(task_list[0]).to have_content 'task3'
        expect(task_list[1]).to have_content 'task2'
        expect(task_list[2]).to have_content 'task'
      end
    end
    context '終了期限を昇順にソート' do
      it 'タスクが終了期限の昇順に並んでいる' do
        # あらかじめタスク並び替えの確認テストで使用するためのタスクを二つ作成する
        visit root_path
        # ソートのプルダウンを終了期限が早い順に指定
        select '終了期限が早い順', from: 'sort'
        click_button 'ソート'
        task_list = all('.task_row') # タスク一覧を配列として取得するため、View側でidを振っておく
        expect(task_list[0]).to have_content 'task'
        expect(task_list[1]).to have_content 'task2'
        expect(task_list[2]).to have_content 'task3'
      end
    end
  end
  describe 'タスク登録画面' do
    before do
      @task = FactoryBot.create(:task, name: 'task')
      @task2 = FactoryBot.create(:second_task, name: 'task2')
      @task3 = FactoryBot.create(:third_task, name: 'task3')
      @labeling1 = FactoryBot.create(:labeling)
      @labeling2 = FactoryBot.create(:second_labeling)
    end
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存される' do
        # new_task_pathにvisitする（タスク登録ページに遷移する）
        # 1.ここにnew_task_pathにvisitする処理を書く
        visit new_task_path
        # 「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄に
        # タスクのタイトルと内容をそれぞれfill_in（入力）する
        # 2.ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in '名前', with: 'new task'
        # 3.ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in '詳細', with: 'new task detail'
        # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
        # 4.「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
        check 'task_label_ids_1'
        click_on '登録'
        # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
        # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
        # 5.タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
        expect(page).to have_content 'new task'
      end
    end
  end
  describe 'タスク詳細画面' do
    before do
      @task = FactoryBot.create(:task, name: 'task')
      @labeling1 = FactoryBot.create(:labeling)
    end
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示されたページに遷移する' do
         visit root_path
         click_on '詳細'
         expect(page).to have_content 'task'
       end
     end
  end
end
