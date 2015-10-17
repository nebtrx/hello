require 'spec_helper'

RSpec.bdd.uic "Button" do

  story "Valid" do
    scenario "Success" do
      given_I_have_signed_in

      When "I attempt to sign out" do
        click_link "Sign Out"
      end

      Then "I should see a confirmation message" do
        expect_flash_notice "You have signed out!"
      end

      then_I_expect_to_be_signed_out

      Then "and my access token should be removed from the database" do
        expect(User.count).to        eq(1)
        expect(Credential.count).to  eq(2)
        expect(Access.count).to      eq(0)
      end
    end
  end

end
