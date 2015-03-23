shared_examples "require_sign_in" do
  it "redirects to the root path" do
    clear_current_user
    action
    response.should redirect_to root_path
  end
end

shared_examples "require_admin" do
  it "redirects to home path" do
    set_current_user_session
    action
    response.should redirect_to home_path
  end
end

shared_examples "tokenable" do
  it "generates a token when a user is created" do
    expect(object.token).to be_present
  end
end