ActiveAdmin.register Incidents::DispatchLog, as: 'Dispatch Log' do
  menu parent: 'Incidents'

  actions :index, :show

  filter :chapter
  filter :incident_number
  filter :county_name
  filter :created_at

  index do
    column("CID") { |msg| msg.chapter_id }
    column :message_number
    column :incident_number
    column :county_name
    column :num_dials
    actions
  end

  show do |log|
    panel "Log" do
      table_for log.log_items.not_sms_internal do |li|
        column :action_at
        column :action_type
        column :recipient
        column :result
      end
    end
    default_main_content
  end

  controller do
    def collection
      @col ||= super.includes{log_items}
    end
  end
end
