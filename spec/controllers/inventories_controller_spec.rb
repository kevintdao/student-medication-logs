require 'rails_helper'
require 'spec_helper'

describe InventoriesController do
  describe "GET /index" do
    it "renders the proper template if logged in" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      get :index
      expect(response).not_to redirect_to(home_index_path)
    end

    it "redirects to the homepage if not logged in" do
      get :index
      expect(response).to redirect_to(home_index_path)
    end

    it "reads the session properly" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      allow_any_instance_of(InventoriesController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:pages)).to eq(25)
      expect(assigns(:selection)).to eq("Ibuprofen")
    end

    it "loads when pages and the search term are nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:inventory)).not_to eq(nil)
    end

    it "loads when pages and the search term are not nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      allow_any_instance_of(InventoriesController).to receive(:session) {{"page_count": 25, "search_term": "Ibuprofen"}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:inventory)).not_to eq(nil)
    end

    it "loads when pages are nil and search term is not" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      allow_any_instance_of(InventoriesController).to receive(:session) {{"search_term": "Ibuprofen"}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:inventory)).not_to eq(nil)
    end

    it "loads when pages are not nil and search term is" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      allow_any_instance_of(InventoriesController).to receive(:session) {{"page_count": 25}}
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:inventory)).not_to eq(nil)
    end
  end

  describe "POST /set_page_count" do
    it "should not allow a non-nurse to set the count" do
      post :set_page_count, page_count: {page_count: 25}
      expect(response).to redirect_to(home_index_path)
    end

    it "should set the page count if the user is a nurse" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :set_page_count, page_count: {page_count: 25}
      expect(assigns(:pages)).to eq("25")
      expect(response).to redirect_to(inventories_path)
    end
  end

  describe "POST /search_inv" do
    it "should not allow a non-nurse to search the inventory" do
      post :search_inv, search_term: {search_term: "Ibuprofen"}
      expect(response).to redirect_to(home_index_path)
    end

    it "should set the page count if the user is a nurse" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :search_inv, search_term: {search_term: "Ibuprofen"}
      expect(assigns(:search)).to eq("Ibuprofen")
      expect(response).to redirect_to(inventories_path)
    end
  end

  describe "POST /new_item" do
    it "should not allow a non-nurse to create an item" do
      post :new_item, item: {medName: "Ibuprofen", studentName: "John Doe", amount: "100", notes: "Testing from Rspec"}
      expect(response).to redirect_to(home_index_path)
    end

    it "should allow a nurse to create an item and set variables" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :new_item, item: {medName: "Ibuprofen", studentName: "John Doe", amount: "100", notes: "Testing from Rspec"}
      expect(assigns(:medName)).to eq("Ibuprofen")
      expect(assigns(:studentName)).to eq(["John", "Doe"])
      expect(assigns(:amount)).to eq(100)
      expect(assigns(:notes)).to eq("Testing from Rspec")
    end

    it "should set the student to nil when no student is provided" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :new_item, item: {medName: "Ibuprofen", studentName: "No Student", amount: "100", notes: "Testing from Rspec"}
      expect(assigns(:studentName)).to eq(nil)
    end

    it "should associate to a medication if there is one that matches" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :new_item, item: {medName: "METANDREN", studentName: "John Doe", amount: "100", notes: "Testing from Rspec"}
      expect(assigns(:medID)).not_to eq(nil)
    end

    it "reloads the page when a required field is balnk" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :new_item, item: {medName: "", studentName: "John Doe", amount: "", notes: "Testing from Rspec"}
      expect(response).to redirect_to(inventories_new_path)
    end

    it "redirects when the amount is not a number" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :new_item, item: {medName: "Metandren", studentName: "John Doe", amount: "Not-a-number", notes: "Testing from Rspec"}
      expect(response).to redirect_to(inventories_new_path)
    end
  end
  describe "POST /change_notes" do
    it "should not allow a non-nurse to change notes" do
      post :change_notes, notes: {notes: "This is an Rspec note", id: 1}
      expect(response).to redirect_to(home_index_path)
    end

    it "should cause an error when no note is passed" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :change_notes, {}
      expect(flash[:error]).to eq("There was a problem editing this note")
      expect(response).to redirect_to(inventories_path)
    end

    it "should update the note for a nurse with valid input" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :change_notes, notes: {notes: "This is an Rspec note", id: 1}
      expect(assigns(:id)).to eq("1")
      expect(assigns(:newNotes)).to eq("This is an Rspec note")
      expect(flash[:notice]).to eq("Notes have been updated successfully")
      expect(response).to redirect_to(inventories_path)
    end
  end

  describe "POST /change_amount" do
    before(:each) do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end
    it "should not allow a non-nurse to change the amount" do
      post :change_amount, amount: {amount: "100", id: 1}
      expect(response).to redirect_to(home_index_path)
    end
    it "should raise an error if the amount is nil" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :change_amount
      expect(flash[:error]).to eq("There was a problem updating this amount")
      expect(response).to redirect_to(inventories_path)
    end
    it "should raise an error if the amount field is blank" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :change_amount, amount: {amount: "", id: 1}
      expect(assigns(:amount)).to eq("")
      expect(assigns(:id)).to eq("1")
      expect(flash[:warning]).to eq("You cannot leave the amount field blank")
      expect(response).to redirect_to('http://test.hostwhere_i_came_from')
    end
    it "should raise an error if the amount field is blank" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :change_amount, amount: {amount: "notANum", id: 1}
      expect(assigns(:amount)).to eq("notANum")
      expect(assigns(:id)).to eq("1")
      expect(flash[:warning]).to eq("You must enter a valid whole number into the amount field")
      expect(response).to redirect_to('http://test.hostwhere_i_came_from')
    end
    it "should reject negative numbers" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :change_amount, amount: {amount: "-1", id: 1}
      expect(assigns(:amount)).to eq(-1)
      expect(assigns(:id)).to eq("1")
      expect(flash[:warning]).to eq("You must enter a number greater than or equal to 0 in the amount field")
      expect(response).to redirect_to('http://test.hostwhere_i_came_from')
    end
    it "should accept valid numbers and update the amount" do
      controller.instance_variable_set(:@current_user, User.where(email: 'nurse1@gmail.com').first)
      post :change_amount, amount: {amount: "50", id: 1}
      expect(assigns(:amount)).to eq(50)
      expect(assigns(:id)).to eq("1")
      expect(flash[:notice]).to eq("Amount has been successfully updated")
      expect(response).to redirect_to('http://test.hostwhere_i_came_from')
    end
  end
end

