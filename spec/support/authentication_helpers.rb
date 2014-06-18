module AuthenticationHelpers
	def valid_sign_in(user, options={})
		if options[:no_capybara]
			# Sign in when not using Capybara.
			remember_token = User.new_remember_token
			cookies[:remember_token] = remember_token
			user.update_attribute(:remember_token, User.digest(remember_token))
		else
			visit signin_path
			fill_in "Email",    with: user.email
			fill_in "Password", with: user.password
			click_button "Sign in"
		end
	end

	def fill_signup_with_valid_user(user)
		fill_in "Name", with: user.name
		fill_in "Email", with: user.email
		fill_in "Password", with: user.password
		fill_in "Confirmation", with: user.password_confirmation
	end

	shared_examples_for "success sign in" do
		it { should have_title(user.name) }
		it do
      should have_link('Profile', href: user_path(user))
      should have_link('Settings', href: edit_user_path(user))
      should have_link('Sign out', href: signout_path)
      should_not have_link('Sign in', href: signin_path)

      if user.admin?
        should have_link('Админ', href: '#')
        should have_link('Курсы', href: courses_path)
        should have_link('Пользователи', href: '#')
      end
    end

		it { should_not have_link('Sign in', href: signin_path) }
  end

  shared_examples_for 'check_access_to_page' do |success_page_title|
    describe "visiting for not auth user" do
      before { visit target_path }
      it { should have_title('Sign in') }
    end

    describe "visiting for not admin user" do
      before do
        valid_sign_in user, no_capybara: true
        get target_path
      end

      specify { expect(response).to redirect_to(root_path) }
    end

    describe "visiting for admin user" do
      before do
        valid_sign_in admin
        visit target_path
      end

      it { should have_title(success_page_title) }
    end
  end
end