require "spec_helper"

describe User do
  let(:user){create(:user)}
  before(:all) do
    @event = create(:event)
  end

  describe "#not_attending_event?" do
    it "prevents deleting" do
      user.stub(:upcoming_events).and_return([@event])
      user.destroy
      expect(user.deleted?).to eq false
      expect(user.deleted_at).to eq nil
      expect(user.errors.full_messages.size).to eq 1
      expect(user.errors.full_messages.first).to include(@event.name)
    end

    it "allows deleting" do
      user.destroy
      expect(user.deleted?).to eq true
      expect(user.errors.full_messages).to be_empty
    end

  end
end
