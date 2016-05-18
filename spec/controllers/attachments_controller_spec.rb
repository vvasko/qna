require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:attachment) { create(:attachment, attachable: question) }

  before(:each) do
    request.env["HTTP_REFERER"] = 'where_i_came_from'
  end



  describe 'DELETE #destroy' do
    sign_in_user
    before{ attachment }
    context 'Authenticated user deletes his attachment' do
      let!(:question) { create(:question, user: @user) }
      let!(:attachment) { create(:attachment, attachable: question) }
      it 'deletes attachment' do
        expect { delete :destroy, id: attachment, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'redirects to question view' do
        delete :destroy, id: attachment, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated user deletes foreign attachment' do
      it 'does not delete an answer' do
        expect {delete :destroy, id: attachment, format: :js }.to_not change(Attachment, :count)
      end

      it 'redirects to back' do
        delete :destroy, id: attachment, format: :js
        expect(response).to redirect_to 'where_i_came_from'
      end
    end

  end


end
