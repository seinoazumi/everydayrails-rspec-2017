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
    let(:user) { FactoryBot.create(:user) }
    let(:project) { FactoryBot.create(:project, owner: user) }

    context "認可されたユーザーとして" do
      it "プロジェクトを更新できること" do
        project_params = FactoryBot.attributes_for(:project,
          name: "New Project Name")
        sign_in user
        patch :update, params: { id: project.id, project:project_params }
        expect(project.reload.name).to eq "New Project Name"
      end
    end

    context "認可されていないユーザーとして" do
      let(:other_user) { FactoryBot.create(:user) }
      let(:project) { FactoryBot.create(:project, owner: other_user, name: "Same Old Name") }

      it "プロジェクトを更新できないこと" do
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        sign_in user
        patch :update, params: { id: project.id, project: project_params }
        expect(project.reload.name).to eq "Same Old Name"
      end

      it "ダッシュボードにリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        sign_in user
        patch :update, params: { id: project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: project.id, project: project_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: project.id, project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#destroy" do
    
    let!(:user) { FactoryBot.create(:user) }
    let!(:project) { FactoryBot.create(:project, owner: user) }
    
    context "認可されたユーザーとして" do
      it "プロジェクトを削除できること" do
        sign_in user
        expect {
          delete :destroy, params: { id: project.id }
      }.to change(user.projects, :count).by(-1)
      end
    end

    context "認可されていないユーザーとして" do
      let!(:other_user) { FactoryBot.create(:user) }

      it "プロジェクトを削除できないこと" do
        sign_in other_user
        expect {
          delete :destroy, params: { id: project.id }
        }.to_not change(Project, :count)
      end

      it "ダッシュボードにリダイレクトすること" do
        sign_in other_user
        delete :destroy, params: { id: project.id }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      it "プロジェクトを削除できないこと" do
        expect {
          delete :destroy, params: { id: project.id }
        }.to_not change(Project, :count)
      end

      it "302レスポンスを返すこと" do
        delete :destroy, params: { id: project.id }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        delete :destroy, params: { id: project.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
