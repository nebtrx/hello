require_dependency "hello/application_controller"

#
# IT IS RECOMMENDED THAT YOU DO NOT OVERRIDE THIS FILE IN YOUR APP
#

module Hello
module Classic
  class RegistrationController < ApplicationController

    before_actions do
      actions(:reset, :save) { fetch_registration_reset_ivar }
      actions(:reset_token)  { clear_hello_session }
    end


    # GET /hello/classic/sign_up
    def sign_up
      @sign_up = SignUp.new
    end

        # POST /hello/classic/sign_up
        def create
          @sign_up = SignUp.new(sign_up_params)
          @credential = @sign_up.credential
          @password = sign_up_params[:password]

          c = Hello.config(:sign_up)

          if @sign_up.save
            flash[:notice] = t("hello.messages.classic.registration.sign_up.notice")
            instance_eval(&c.success_block)
          else
            instance_eval(&c.failure_block)
          end
        end

            # GET /hello/classic/after_sign_up
            def after_sign_up
            end







    # GET /hello/classic/sign_in
    def sign_in
      @sign_in = SignIn.new
    end

        # POST /hello/classic/sign_in
        def authenticate
          @sign_in = SignIn.new(self)
          @credential = @sign_in.credential

          c = Hello.config(:sign_in)

          if @sign_in.authenticate
            flash[:notice] = t("hello.messages.classic.registration.sign_in.notice")
            instance_eval(&c.success_block)
          else
            instance_eval(&c.failure_block)
          end
        end

            # GET /hello/classic/after_sign_in
            def after_sign_in
            end






    # GET /hello/classic/forgot
    def forgot
      @forgot_password = ForgotPassword.new
    end

        # POST /hello/classic/forgot
        def ask
          @forgot_password = ForgotPassword.new(forgot_login_param)
          @credential = @forgot_password.credential

          c = Hello.config(:forgot_password)

          if @forgot_password.reset
            flash[:notice] = t("hello.messages.classic.registration.forgot_password.notice")
            instance_eval(&c.success_block)
          else
            instance_eval(&c.failure_block)
          end
        end

            # GET /hello/classic/after_forgot
            def after_forgot
            end





    # GET /hello/classic/reset/token/:token
    def reset_token
      @reset_password = ResetPassword.new(params[:token])
      if @reset_password.credential
        session[:hello_reset_token] = params[:token]
        redirect_to classic_reset_path
      else
        redirect_to classic_forgot_path, alert: "This link has expired, please ask for a new link"
      end
    end

        # GET /hello/classic/reset
        def reset
        end

            # POST /hello/classic/reset
            def save
              c = Hello.config(:reset_password)

              if @reset_password.update_password(reset_password_param)
                @credential.invalidate_password_token
                flash[:notice] = t("hello.messages.classic.registration.reset_password.notice")
                instance_eval(&c.success_block)
              else
                instance_eval(&c.failure_block)
              end
            end

                # GET /hello/classic/after_reset
                def after_reset
                end



    # GET /hello/classic/confirm_email/send
    def confirm_email_send
      token = hello_credential.reset_email_token!
      url = classic_confirm_email_token_url(token)
      Hello::RegistrationMailer.confirm_email(hello_credential, url).deliver!
      flash[:notice] = t("hello.messages.classic.registration.send_confirmation.notice", email: hello_credential.email)
      redirect_to :back
    end

        # GET /hello/classic/confirm_email/token/:token
        def confirm_email_token
          @confirm_email = ConfirmEmail.new(params[:token])
          if @confirm_email.found_credential?
            @confirm_email.confirm_email!
            flash[:notice] = @confirm_email.message
            redirect_to classic_after_confirm_email_path
          else
            flash[:alert] = @confirm_email.alert_message
            redirect_to classic_confirm_email_expired_path
          end
        end

            # GET /hello/classic/confirm_email/expired
            def confirm_email_expired
            end

            # GET /hello/classic/after_confirm_email
            def after_confirm_email
            end


    private

        def fetch_registration_reset_ivar
          return redirect_to classic_forgot_path unless session[:hello_reset_token]
          @reset_password = ResetPassword.new(session[:hello_reset_token])
          @credential = @reset_password.credential
        end

        def sign_up_params
          params.require(:sign_up)
        end

        def forgot_login_param
          params.require(:forgot_password)[:login]
        end

        def reset_password_param
          params.require(:reset_password)[:password]
        end





  end

end
end
