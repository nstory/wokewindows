describe OrganizationsController do
  describe "show" do
    let!(:officer_other) { create(:officer_other) }
    it "respond with 200 when passed a well-formatted ID param" do
      get :show, params: {:id => officer_other.organization_param}
      expect(response.status).to eq(200)
    end

    it "responds with 404 when passed a badly formed param" do
      expect {
        get :show, params: {:id => officer_other.organization}
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "responds with 404 when passed an organization that doesn't exist" do
      expect {
        get :show, params: {:id => Officer.organization_to_param("oops doesn't exist")}
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
