require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do

  context "redirect new to sign_in" do
    subject { get "/users/sign_up" }
    it { expect(subject).to redirect_to("/users/sign_in") }
  end

end
