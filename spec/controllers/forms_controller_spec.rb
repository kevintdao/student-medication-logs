require 'rails_helper'
require 'spec_helper'

describe FormsController do
  describe "GET /index" do
    it "renders the proper template" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      get :index
      expect(response).not_to redirect_to(forms_path)
    end

    it "reads the session correctly" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      allow_any_instance_of(FormsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:pages)).to eq(25)
      expect(assigns(:selection)).to eq("Ibuprofen")
    end

    it "loads when pages and the search term are nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:forms)).not_to eq(nil)
    end

    it "loads when pages and the search term are not nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      allow_any_instance_of(FormsController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:forms)).not_to eq(nil)
    end

    it "loads when pages are nil and search term is not" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      allow_any_instance_of(FormsController).to receive(:session) {{"search_term": "Ibuprofen"}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:forms)).not_to eq(nil)
    end


    it "loads when pages are not nil and search term is" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      allow_any_instance_of(FormsController).to receive(:session) {{"page_count": 25}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:forms)).not_to eq(nil)
    end
  end

  describe "POST /set_page_count" do

    it "should set the page count regardless of user type" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :set_page_count, page_count: {page_count: 25}
      expect(assigns(:pages)).to eq("25")
      expect(response).to redirect_to(forms_path)
    end
  end

    describe "POST /search_forms" do
      it "should allow anybody who is logged in to search forms" do
        controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
        post :search_forms, search_term: {search_term: "Ibuprofen"}
        expect(assigns(:search)).to eq("Ibuprofen")
        expect(response).to redirect_to(forms_path)
      end
    end

    describe "POST /change_body" do
      before(:each) do
        request.env["HTTP_REFERER"] = "where_i_came_from"
      end
      it "should error out on nil params" do
        controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
        post :change_body, {}, {}
        expect(flash[:error]).to eq("There was a problem editing this form")
        expect(response).to redirect_to('http://test.hostwhere_i_came_from')
      end

      it "should not be accessed by a non-nurse" do
        post :change_body, {}, {}
        expect(response).to redirect_to(home_index_path)
      end

      it "should correctly set variables, flash and redirect" do
        controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
        post :change_body, body: {body: "This is a new body from rspec", id: 1}
        expect(flash[:notice]).to eq("Form has been successfully updated. Guardian will have to approve again.")
        expect(assigns(:newBody)).to eq("This is a new body from rspec")
        expect(assigns(:id)).to eq("1")
        expect(response).to redirect_to(forms_path)
      end
    end
  describe "POST /new_form" do
    before(:each) do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end
    it "should error out if the params are nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :new_form, {}, {}
      expect(flash[:error]).to eq("There was a problem creating this form")
      expect(assigns(:form)).to eq(nil)
      expect(response).to redirect_to('http://test.hostwhere_i_came_from')
    end
    it "should not allow a non-nurse access" do
      post :new_form
      expect(response).to redirect_to(home_index_path)
    end
    it "should not accept a blank student name" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :new_form, form: {studentName: nil, body: "This is a test"}
      expect(assigns(:studentName)).to eq(nil)
      expect(assigns(:body)).to eq("This is a test")
      expect(flash[:warning]).to eq("You must select a student for this form")
      expect(response).to redirect_to('http://test.hostwhere_i_came_from')
    end
    it "should not accept a blank body" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :new_form, form: {studentName: "Student A", body: ""}
      expect(assigns(:studentName)).to eq("Student A")
      expect(assigns(:body)).to eq("")
      expect(flash[:warning]).to eq("You cannot submit a blank form")
      expect(response).to redirect_to('http://test.hostwhere_i_came_from')
    end
    it "should create a valid form given correct params with logged in nurse" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :new_form, form: {studentName: "Student A", body: "This is a test"}
      expect(assigns(:studentName)).to eq(["Student", "A"])
      expect(assigns(:body)).to eq("This is a test")
      expect(assigns(:fname)).to eq("Student")
      expect(assigns(:lname)).to eq("A")
      expect(flash[:notice]).to eq("Form has been successfully created pending guardian approval")
      expect(response).to redirect_to(nurses_path)
    end
    end
  end
