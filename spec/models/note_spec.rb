require 'rails_helper'

RSpec.describe Note, type: :model do
  # subject(:note) { Note.new }
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  it "delegates name to the user who created it" do
    # user = FactoryBot.create(:user, first_name: "Fake", last_name: "User")
    # note = Note.new(user: user)
    # expect(note.user_name).to eq "Fake User"
    user = instance_double("User", name: "Fake User")
    note = Note.new
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq "Fake User"
  end

  # before do
  #   @user = User.create(
  #     first_name: "Joe",
  #     last_name: "Tester",
  #     email: "joetester@example.com",
  #     password: "dottle-nouveau-pavilion-tights-furze"
  #   )

  #   @project = @user.projects.create(
  #     name: "Test Project"
  #   )
  # end

  it "is valid with a user, project, and message" do
    note = Note.new(
      message: "This is a sample note.",
      user: user,
      project: project,
    )
    expect(note).to be_valid
  end

  it(focus: true) { is_expected.to validate_presence_of :message}

  # it "is invalid without a message" do
  #   note = Note.new(message: nil)
  #   note.valid?
  #   expect(note.errors[:message]).to include("can't be blank")
  # end

  describe "search message for a term" do
    before do
      @note1 = project.notes.create(
        message: "This is the first note.",
        user: user,
      )
      @note2 = project.notes.create(
        message: "This is the second note.",
        user: user,
      )
      @note3 = project.notes.create(
        message: "First, preheat the oven.",
        user: user,
      )
    end
    
    context "when a match is found" do
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(@note1, @note3)
        expect(Note.search("first")).to_not include(@note2)
      end
    end

    context "when no match is found" do
      it "returns an empty collection when no results are found" do
        expect(Note.search("message")).to be_empty
      end
    end
  end
end
