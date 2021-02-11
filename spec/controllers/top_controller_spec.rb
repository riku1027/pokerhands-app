require 'rails_helper'

describe TopController, type: :controller do

  describe 'GET #show' do

    describe 'Render' do

      it "renders the :show template" do
        get :show
        expect(response).to render_template :show
      end

    end

  end

  describe 'POST #check' do

    describe 'Redirect' do

      describe 'OK' do
        it "rendirects to the :show " do
          get :check, cards: "S1 H2 D3 C4 H12"
          expect(response).to redirect_to(:root)
        end
      end

      describe 'Alert' do
        it "rendirects to the :show " do
          get :check, cards: "A B C D E"
          expect(response).to redirect_to(:root)
        end
      end

    end

  end

end