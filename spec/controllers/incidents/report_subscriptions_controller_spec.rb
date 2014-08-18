require 'spec_helper'

describe Incidents::ReportSubscriptionsController, :type => :controller do
  include LoggedIn
  render_views

  let(:chapter) { @person.chapter }
  let(:report_type) { 'report' }

  describe '#new' do
    it 'renders' do
      get :new, chapter_id: chapter.to_param, report_type: report_type
      expect(response).to be_success
      expect(response.body).to include('Subscribe')
    end
  end

  describe '#create' do
    it 'creates and redirects to the subscription' do
      post :create, chapter_id: chapter.to_param, report_type: report_type
      expect(response).to be_redirect
      expect(get_sub).to_not be_nil
    end
  end

  describe "with existing subscription" do
    let!(:sub) {FactoryGirl.create :report_subscription, person: @person}
    
    describe '#show' do
      it 'renders' do
        get :show, chapter_id: chapter.to_param, report_type: report_type, id: sub.id
        expect(response).to be_success
        expect(response.body).to include('Unsubscribe')
      end
    end

    describe '#update' do
      it 'changes the frequency' do
        patch :update, chapter_id: chapter.to_param, report_type: report_type, id: sub.id, incidents_report_subscription: {frequency: 'daily'}
        expect(response).to be_redirect
        expect(get_sub.frequency).to eq('daily')
      end
    end

    describe '#destroy' do
      it 'destroys and redirects to the subscription' do
        delete :destroy, chapter_id: chapter.to_param, report_type: report_type, id: sub.id
        expect(response).to be_redirect
        expect{
          get_sub
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  def get_sub
    Incidents::ReportSubscription.where{person_id == my{@person}}.first!
  end

end
