class RenameAttachmentsColumns < ActiveRecord::Migration
  def change
    rename_column :attachments, :attachmentable_id, :attachable_id
    rename_column :attachments, :attachmentable_type, :attachable_type
  end
end
