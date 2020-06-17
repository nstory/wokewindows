describe "root", type: :request do
  it "returns http success" do
    get root_path
    expect(response).to have_http_status(:success)
  end
end
