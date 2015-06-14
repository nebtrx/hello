require "spec_helper"

module Hello
  describe CurrentUserController do
    describe "routing" do
      routes { Hello::Engine.routes }

      it "routes to #edit" do
        expect(get("/user")).to route_to("hello/current_user#edit")
      end

          it "routes to #update" do
            expect(patch("/user")).to route_to("hello/current_user#update")
          end

      
    end
  end
end
