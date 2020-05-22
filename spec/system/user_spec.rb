require 'rails_helper'
RSpec.describe 'ユーザ登録・ログイン・ログアウト機能', type: :system do
  def user_login
    visit new_session_path
    fill_in 'session[email]', with: 'sample@example.com'
    fill_in 'session[password]', with: '00000000'
    click_button 'ログイン'
  end

  def admin_user_login
    visit new_session_path
    fill_in 'session[email]', with: 'admin@example.com'
    fill_in 'session[password]', with: '00000000'
    click_button 'ログイン'
  end

  describe 'ユーザ登録のテスト' do
    context 'ユーザのデータがなくログインしていない状態' do
      it 'ユーザ新規登録のテスト' do
        visit new_user_path
        fill_in 'user[name]', with: 'sample'
        fill_in 'user[email]', with: 'sample@example.com'
        fill_in 'user[password]', with: '00000000'
        fill_in 'user[password_confirmation]', with: '00000000'
        click_on '登録'

        click_link 'マイページ'

        expect(page).to have_content 'sample'
      end
      it 'ログインしていない時はログイン画面に飛ぶテスト' do
        visit root_path
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe 'セッション機能のテスト' do
    before do
      @user = FactoryBot.create(:user)

      user_login
    end

    context 'ログインしていない状態でユーザーのデータがある場合' do
      it 'ログインができること' do
        expect(current_path).to eq root_path
      end
    end

    context '一般ユーザでログインしている状態' do
      it '自分の詳細画面（マイページ）に飛べること' do
        click_link 'マイページ'

        expect(current_path).to eq user_path(1)
      end

      it '一般ユーザが他人の詳細画面に飛ぶとタスク一覧ページに遷移すること' do
        visit user_path(2)
        expect(current_path).to eq root_path
      end

      it 'ログアウトができること' do
        click_link 'ログアウト'
        page.driver.browser.switch_to.alert.accept

        expect(current_path).to eq new_session_path
      end
    end
  end

  describe '管理画面のテスト' do
    before do
      @user = FactoryBot.create(:user)
      @admin_user = FactoryBot.create(:admin_user)
    end

    context '一般ユーザでログインしている状態' do
      it '一般ユーザは管理画面にアクセスできないこと' do
        user_login

        visit admin_users_path
        expect(current_path).to eq root_path
      end
    end

    context '管理者でログインしている状態' do
      before do
        admin_user_login
        click_link '管理'
      end

      it '管理者は管理画面にアクセスできること' do
        expect(current_path).to eq admin_users_path
      end

      it '管理者はユーザを新規登録できること' do
        click_link '新規ユーザー登録'

        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@example.com'
        fill_in 'user[password]', with: '00000000'
        fill_in 'user[password_confirmation]', with: '00000000'
        click_on '登録'

        visit admin_users_path
        expect(page).to have_content 'test'
      end

      it '管理者はユーザの詳細画面にアクセスできること' do
        sleep 1
        click_link 'sample'
        expect(current_path).to eq user_path(1)
      end

      it '管理者はユーザの編集画面からユーザを編集できること' do
        sleep 1
        click_link '編集・削除', href: edit_admin_user_path(1)

        fill_in 'user[name]', with: 'sample_after'
        click_button '登録'

        expect(page).to have_content 'sample_after'
      end

      it '管理者はユーザの削除をできること' do
        sleep 1
        click_link '編集・削除', href: edit_admin_user_path(1)

        click_link 'ユーザーデータを削除する'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'sampleさんのユーザーデータを削除しました'
      end
    end
  end
end
