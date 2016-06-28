require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :request do

  context "redirect new to sign_in" do
    subject { get "/users/password/new" }
    it { expect(subject).to redirect_to("/users/sign_in") }
  end

end
