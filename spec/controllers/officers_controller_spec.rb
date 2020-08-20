describe OfficersController do
    describe "show" do
        let!(:officer) { create(:officer) }
        it "redirects with 301 when only an employee_id is provided" do
            get :show, params: {:id => officer.employee_id}
            expect(response.status).to eq(301)
            expect(response.location).to end_with(officer_path(officer))
        end
    end
end
