require 'spec_helper'
require 'pp'

include AuthenticationHelpers
include ActionView::Helpers::OutputSafetyHelper

describe "User Pages" do
	subject { page }

	describe "edit" do
		let(:user) { FactoryGirl.create(:admin) }
		before do
			valid_sign_in(user)
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_content("Update your profile") }
			it { should have_title("Edit user") }
			it { should have_link('change gravatar', href: 'http://gravatar.com/emails') }
			it { should have_button('Save changes') }
		end

		describe "with invalid information" do
			before { click_button "Save changes" }

			it { should have_content('ошибк') }
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }
			let(:new_email) { "new@email.com" }

			before do
				fill_in "Name",             with: new_name
				fill_in "Email",            with: new_email
				fill_in "Password",         with: user.password
				fill_in "Confirmation", 	with: user.password
				click_button "Save changes"
			end

			it { should have_title(new_name) }
			it { should have_success_message('Your data has been changed') }
			it { should have_link('Sign out', href: signout_path) }

			specify { expect(user.reload.name).to  eq new_name }
			specify { expect(user.reload.email).to eq new_email }
		end

		describe "forbidden attributes" do
			let(:params) do {
				user: {
					admin: false,
					password: user.password,
					password_confirmation: user.password
				}
			}
			end

			before do
				valid_sign_in user, no_capybara: true
				patch user_path(user), params
			end

			specify { expect(user.reload).to be_admin }
		end
	end
end
