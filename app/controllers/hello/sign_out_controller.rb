module Hello
  class SignOutController < SuperSignOutController

    def success
      respond_to do |format|
        # format.html { redirect_to hello.root_path }
        # format.html { redirect_to root_path }
        format.html { render :sign_out }
        format.json { head :reset_content }
      end
    end

  end
end
