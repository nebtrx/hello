module Hello
  class SuperSignOutController < ApplicationController

    # access to all roles

    # GET /hello/sign_out
    def sign_out
      destroy_and_clear_hello_access_token

      @sign_out = SignOutEntity.new
      flash.now[:notice] = @sign_out.success_message
      
      success
    end
    
  end
end
