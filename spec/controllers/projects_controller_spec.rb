require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do

    context "認証済みのユーザーとして" do

      before do
        @user = FactoryBot.create(:user)
      end
    
      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      it "200レスポンスを返すこと" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "認可されたユーザーとして" do
      let(:user) { FactoryBot.create(:user) }
      let(:project) { FactoryBot.create(:project, owner: user) }
      
      it "正常にレスポンスを返すこと" do
        sign_in user
        get :show, params: { id: project.id }
        expect(response).to be_success
      end
    end

    context "認可されていないユーザーとして" do
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user) }
      let(:project) { FactoryBot.create(:project, owner: other_user) }

      it "ダッシュボードにリダイレクトすること" do
        sign_in user
        get :show, params: { id: project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    context "認証済みユーザーとして" do
      let(:user) { FactoryBot.create(:user) }

      it "プロジェクトを追加できること" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in user
        expect {
          post :create,
          params: { project: project_params }
        }.to change(user.projects, :count).by(1)
      end
    end

    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    context "認可されたユーザーとして" do
      let(:user) { FactoryBot.create(:user) }
      let(:project) { FactoryBot.create(:project, owner: user) }

      it "プロジェクトを更新できること" do
        project_params = FactoryBot.attributes_for(:project,
          name: "New Project Name")
        sign_in user
        patch :update, params: { id: project.id, project:project_params }
        expect(project.reload.name).to eq "New Project Name"
      end
    end
  end
end
