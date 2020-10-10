describe OrganizationsController do
  describe "show" do
    let!(:officer_other) { create(:officer_other) }
    it "redirects with 301 to a well-formatted URL slug" do
      get :show, params: {:id => officer_other.organization}
      expect(response.status).to eq(301)
      expect(response.location).to end_with(officer_other.organization.parameterize)
    end

    it "responds with 404 when an organization isn't found" do
      expect {
        get :show, params: {:id => "oops doesn't exist"}
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
